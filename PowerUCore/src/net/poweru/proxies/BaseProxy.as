package net.poweru.proxies
{
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	
	import mx.messaging.messages.HTTPRequestMessage;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.Base64Encoder;
	import mx.utils.ObjectUtil;
	
	import net.poweru.ApplicationFacade;
	import net.poweru.NotificationNames;
	import net.poweru.delegates.BaseDelegate;
	import net.poweru.delegates.UserManagerDelegate;
	import net.poweru.delegates.UtilsManagerDelegate;
	import net.poweru.events.DelegateEvent;
	import net.poweru.model.DataSet;
	import net.poweru.utils.ExpectedResultCounter;
	import net.poweru.utils.InputCollector;
	import net.poweru.utils.PowerUResponder;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class BaseProxy extends Proxy implements IProxy
	{
		protected var loginProxy:LoginProxy;
		protected var primaryDelegateClass:Class;
		protected var updatedDataNotification:String;
		protected var requestedFields:Array = [];
		protected var getAllFields:Array = [];
		protected var fieldChoices:Object = null;
		protected var modelName:String;
		protected var inputCollector:InputCollector;
		protected var haveData:Boolean = false;
		protected var saveCounter:ExpectedResultCounter;
		protected var browserServicesProxy:BrowserServicesProxy;
		
		public function BaseProxy(proxyName:String, primaryDelegateClass:Class, updatedDataNotification:String, modelName:String = null, choiceFields:Array = null)
		{
			this.primaryDelegateClass = primaryDelegateClass;
			super(proxyName, new DataSet());
			loginProxy = facade.retrieveProxy(LoginProxy.NAME) as LoginProxy;
			browserServicesProxy = (facade as ApplicationFacade).retrieveOrRegisterProxy(BrowserServicesProxy) as BrowserServicesProxy;
			this.updatedDataNotification = updatedDataNotification;
			this.modelName = modelName;
			inputCollector = new InputCollector(choiceFields);
			inputCollector.addEventListener(Event.COMPLETE, onInputCollected);
			for each (var fieldName:String in choiceFields)
			{
				var token:AsyncToken = new UtilsManagerDelegate(new PowerUResponder(onGetChoicesSuccess, onGetChoicesError, onFault)).getChoices(modelName, fieldName);
				token.fieldName = fieldName;
			}
			saveCounter = new ExpectedResultCounter(onSaveResultsReceived);
		}
		
		public function get dataSet():DataSet
		{
			return data as DataSet;
		}
		
		/*	If we have the results from a prior getAll call that included
			the requested fields, just send those along.  Otherwise, actually
			retrieve them from the back end. */
		public function getAll(fields:Array):void
		{
			for each (var field:String in fields)
			{
				if (haveData == false)
					getFiltered({}, fields);
				else
				{
					var alreadyHaveDataAndFields:Boolean = haveData;
					if (getAllFields.indexOf(field) == -1)
					{
						getAllFields = fields;
						getFiltered({}, fields);
						alreadyHaveDataAndFields = false;
						break;
					}
				}
			}
			
			if (alreadyHaveDataAndFields)
				sendNotification(updatedDataNotification, new DataSet(ObjectUtil.copy(dataSet.toArray()) as Array));
		}
		
		public function getOne(pk:Number, fields:Array):void
		{
			var filters:Object = {'exact' : {'id' : pk}};
			new primaryDelegateClass(new PowerUResponder(onGetOneSuccess, onGetOneError, onFault)).getFiltered(loginProxy.authToken, filters, fields);
		}
		
		public function getFiltered(filters:Object, fields:Array):void
		{
			for each (var field:String in fields)
				if (requestedFields.indexOf(field) == -1)
					requestedFields.push(field);
					
			new primaryDelegateClass(new PowerUResponder(onGetFilteredSuccess, onGetFilteredError, onFault)).getFiltered(loginProxy.authToken, filters, fields);
		}
		
		// override this
		public function create(parameters:Object):void
		{}
		
		public function deleteObject(pk:Number):void
		{
			
		}
		
		public function save(data:Object, oldItem:Object=null):void
		{
			saveCounter.increment();
			var cachedItem:Object = oldItem ? oldItem : dataSet.findByPK(data['id']);
			
			var delegate:BaseDelegate = new primaryDelegateClass(new PowerUResponder(onSaveSuccess, onSaveError, onSaveFault)) as BaseDelegate;
			delegate.addEventListener(DelegateEvent.NOUPDATE, onNoUpdate);
			delegate.update(loginProxy.authToken, cachedItem, data);
		}
		
		// Keep track of save calls that don't actually result in a remote call.
		protected function onNoUpdate(event:DelegateEvent):void
		{
			var delegate:BaseDelegate = event.currentTarget as BaseDelegate;
			delegate.removeEventListener(DelegateEvent.NOUPDATE, onNoUpdate);
			saveCounter.decrement();
		}
		
		public function clear():void
		{
			requestedFields = [];
			data = new DataSet();
			getAllFields = [];
			haveData = false;
		}
		
		public function findByPK(pk:Number):Object
		{
			return ObjectUtil.copy(dataSet.findByPK(pk));
		}
		
		public function getChoices():void
		{
			if (fieldChoices != null)
				sendNotification(NotificationNames.UPDATECHOICES, fieldChoices, proxyName);
		}
		
		/*	Upload a file.  A single use auth token must be obtained from the
			server, which is why we use an input collector. */ 
		protected function uploadFile(file:FileReference, data:Object, url:String, fieldName:String):void
		{
			var uploadInputCollector:InputCollector = new InputCollector(['file', 'request', 'fieldName', 'authToken']);
			uploadInputCollector.addEventListener(Event.COMPLETE, onUploadInputsCollected);
			
			var urlVariables:URLVariables = new URLVariables();
			var request:URLRequest = new URLRequest(url);
			
			for (var key:String in data)
			{
				urlVariables[key] = data[key];
			}
			
			request.method = URLRequestMethod.POST;
			request.data = urlVariables;

			file.addEventListener(IOErrorEvent.IO_ERROR, onUploadError);
			file.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHTTPStatusError);
			
			uploadInputCollector.addInput('file', file);
			uploadInputCollector.addInput('request', request);
			uploadInputCollector.addInput('fieldName', fieldName);

			obtainSingleUseAuthToken(uploadInputCollector);
		}
		
		/*	Will obtain a single use auth token and add it to the input
			collector under the name 'authToken'. */
		protected function obtainSingleUseAuthToken(collector:InputCollector):void
		{
			new UserManagerDelegate(new PowerUResponder(onSingleUseAuthTokenSuccess, onSingleUseAuthTokenError, onFault)).obtainSingleUseAuthToken(loginProxy.authToken, collector);
		}
		
		protected function uploadByteArray(bytes:ByteArray, data:Object, url:String, fieldName:String):void
		{
			var urlVariables:URLVariables = new URLVariables();
			var request:URLRequest = new URLRequest(url);
			
			for (var key:String in data)
			{
				urlVariables[key] = data[key];
			}
			
			// Add image to the request
			var encoder:Base64Encoder = new Base64Encoder();
			encoder.encodeBytes(bytes);
			urlVariables[fieldName] = encoder.flush();
			
			request.method = URLRequestMethod.POST;
			request.data = urlVariables;
			
			var loader:URLLoader = new URLLoader(request);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onUploadError);
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHTTPStatus);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			loader.addEventListener(Event.COMPLETE, onUploadComplete);
			loader.load(request);
		}
		
		public function uploadCSV(file:FileReference, modelName:String):void
		{
			uploadFile(file, {'model' : modelName}, browserServicesProxy.csvUploadURL, modelName);
		}
		
		
		// result handlers
		
		protected function onGetFilteredSuccess(data:ResultEvent):void
		{
			dataSet.mergeData(data.result.value as Array);
			haveData = true;
			sendNotification(updatedDataNotification, dataSet);
		}
		
		protected function onGetFilteredError(data:ResultEvent):void
		{
			trace('getFiltered error');
		}
		
		protected function onSaveResultsReceived():void
		{
			sendNotification(updatedDataNotification, dataSet);
		}
		
		protected function onSaveSuccess(data:ResultEvent):void
		{
			dataSet.addOrReplace(data.token['updatedItem']);
			saveCounter.decrement();
		}
		
		protected function onSaveError(data:ResultEvent):void
		{
			saveCounter.decrement();
			trace('save error');
		}
		
		protected function onSaveFault(info:FaultEvent):void
		{
			saveCounter.decrement();
			trace('save fault');
		}
		
		/*	For now, once an object is created, we then fetch that object. We
			request all of the fields that have ever been requested since the
			cache was last flushed.  Eventually, we should probably just have
			the backend return the fields we want right here. */
		protected function onCreateSuccess(data:ResultEvent):void
		{
			var newPK:Number = data.result.value.id;
			if (requestedFields.length > 0)
			{
				getFiltered({'exact' : {'id' : newPK}}, requestedFields);
			}
			else
				sendNotification(updatedDataNotification);
		}
		
		protected function onCreateError(data:ResultEvent):void
		{
			trace('create error');
		}
		
		protected function onDeleteSuccess(data:ResultEvent):void
		{
		}
		
		protected function onDeleteError(data:ResultEvent):void
		{
			trace('delete error');
		}

		protected function onGetChoicesSuccess(data:ResultEvent):void
		{
			inputCollector.addInput(data.token.fieldName, data.result.value);
		}
		
		protected function onGetChoicesError(data:ResultEvent):void
		{
			trace('error getting choices for field ' + data.token.fieldName);
		}
		
		protected function onFault(info:FaultEvent):void
		{
			trace('fault');
		}
		
		protected function onUploadComplete(event:Event):void
		{
			trace('upload complete');
			
			var loader:URLLoader = event.target as URLLoader;
			if (loader)
			{
				loader.removeEventListener(IOErrorEvent.IO_ERROR, onUploadError);
				loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onHTTPStatus);
				loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
				loader.removeEventListener(Event.COMPLETE, onUploadComplete);
			}
			/*	Since we don't get anything like an AsyncToken to uniquely
				identify this upload, we will send the name of the proxy in
				the notification as a less-specific but still useful way for
				listeners to decide if this is relevant to them. */
			sendNotification(NotificationNames.UPLOADCOMPLETE, proxyName);
		}
		
		protected function onHTTPStatusError(event:HTTPStatusEvent):void
		{
			trace('upload error: http status');
		}
		
		protected function onUploadError(event:IOErrorEvent):void
		{
			trace('upload error');
			sendNotification(NotificationNames.UPLOADFAILED, proxyName);
		}
		
		protected function onHTTPStatus(event:HTTPStatusEvent):void
		{
			trace('http status event');
		}
		
		protected function onSecurityError(event:SecurityErrorEvent):void
		{
			trace('security error event');
			sendNotification(NotificationNames.UPLOADFAILED, proxyName);
		}
		
		protected function onInputCollected(event:Event):void
		{
			var collector:InputCollector = event.target as InputCollector;
			collector.removeEventListener(Event.COMPLETE, onInputCollected);
			fieldChoices = collector.object;
			sendNotification(NotificationNames.UPDATECHOICES, ObjectUtil.copy(collector.object), proxyName);
		}
		
		protected function onGetOneSuccess(event:ResultEvent):void
		{
			var item:Object = event.result.value[0];
			dataSet.addOrReplace(item);
			sendNotification(NotificationNames.RECEIVEDONE, item, modelName);
		}
		
		protected function onGetOneError(data:ResultEvent):void
		{
			trace('error getting one');
		}
		
		/*	When all upload inputs have been collectd, perform the upload. */
		protected function onUploadInputsCollected(event:Event):void
		{
			var collector:InputCollector = event.target as InputCollector;
			collector.removeEventListener(Event.COMPLETE, onUploadInputsCollected);
			
			var file:FileReference = collector.object['file'] as FileReference;
			var request:URLRequest = collector.object['request'] as URLRequest;
			var fieldName:String = collector.object['fieldName'] as String;
			var authToken:String = collector.object['authToken'] as String;
			
			(request.data as URLVariables)['auth_token'] = authToken;
			
			file.upload(request, fieldName);
		}
		
		/*	If an InputCollector is found on the AsyncToken, add the result
			value to it under the name 'authToken'.  Otherwise, do nothing. */
		protected function onSingleUseAuthTokenSuccess(event:ResultEvent):void
		{
			var collector:InputCollector = event.token['inputCollector'] as InputCollector;
			if (collector)
				collector.addInput('authToken', event.result['value']);
		}
		
		protected function onSingleUseAuthTokenError(event:ResultEvent):void
		{
			trace('error obtaining single use auth token');
		}
	}
}