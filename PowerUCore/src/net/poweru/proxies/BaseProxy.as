package net.poweru.proxies
{
	import com.adobe.utils.DateUtil;
	
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
	
	import mx.collections.ArrayCollection;
	import mx.messaging.messages.HTTPRequestMessage;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.Base64Encoder;
	import mx.utils.ObjectUtil;
	
	import net.poweru.ApplicationFacade;
	import net.poweru.Constants;
	import net.poweru.NotificationNames;
	import net.poweru.delegates.BaseDelegate;
	import net.poweru.delegates.UserManagerDelegate;
	import net.poweru.delegates.UtilsManagerDelegate;
	import net.poweru.events.DelegateEvent;
	import net.poweru.model.DataSet;
	import net.poweru.utils.BatchRequestTracker;
	import net.poweru.utils.ExpectedResultCounter;
	import net.poweru.utils.InputCollector;
	import net.poweru.utils.PKArrayCollection;
	import net.poweru.utils.PowerUResponder;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class BaseProxy extends Proxy implements IProxy
	{
		protected var getFilteredMethodName:String = null;
		protected var loginProxy:LoginProxy;
		protected var primaryDelegateClass:Class;
		protected var updatedDataNotification:String;
		protected var fieldChoices:Object = null;
		protected var modelName:String;
		protected var inputCollector:InputCollector;
		protected var _haveData:Boolean = false;
		protected var saveCounter:ExpectedResultCounter;
		protected var browserServicesProxy:BrowserServicesProxy;
		// names of fields which arrive as an ISO 8601 string. They will be automatically converted by the onGetFilteredSuccess method.
		protected var dateTimeFields:Array = [];
		protected var fields:Array;
		protected var createArgNamesInOrder:Array = [];
		protected var createOptionalArgNames:Array = [];
		protected var batchTracker:BatchRequestTracker;
		
		/*	updatedDataNotification is the notification which should be sent
			when new data has entered the proxy.
		
			fields is an array of field names that should be loaded
		
			choiceFields is an array of field names for which choices should be
			loaded.
		*/
		public function BaseProxy(proxyName:String, primaryDelegateClass:Class, updatedDataNotification:String, fields:Array, modelName:String = null, choiceFields:Array = null)
		{
			this.primaryDelegateClass = primaryDelegateClass;
			super(proxyName, new DataSet());
			loginProxy = facade.retrieveProxy(LoginProxy.NAME) as LoginProxy;
			browserServicesProxy = (facade as ApplicationFacade).retrieveOrRegisterProxy(BrowserServicesProxy) as BrowserServicesProxy;
			this.updatedDataNotification = updatedDataNotification;
			this.modelName = modelName;
			this.fields = fields;
			inputCollector = new InputCollector(choiceFields);
			inputCollector.addEventListener(Event.COMPLETE, onInputCollected);
			for each (var fieldName:String in choiceFields)
			{
				var token:AsyncToken = new UtilsManagerDelegate(new PowerUResponder(onGetChoicesSuccess, onGetChoicesError, onFault)).getChoices(modelName, fieldName);
				token.fieldName = fieldName;
			}
			saveCounter = new ExpectedResultCounter(onSaveResultsReceived);
			createBatchTracker();
		}
		
		public function get dataSet():DataSet
		{
			return data as DataSet;
		}
		
		public function get haveData():Boolean
		{
			return _haveData;
		}
		
		/*	If we have the results from a prior getAll call that included
			the requested fields, just send those along.  Otherwise, actually
			retrieve them from the back end. */
		public function getAll():void
		{
			if (haveData == false)
				getFiltered(applyStateFilters({}));
			else
				sendNotification(updatedDataNotification, new DataSet(ObjectUtil.copy(dataSet.toArray()) as Array));
		}
		
		/*	get one from the backend */
		public function getOne(pk:Number):void
		{
			var filters:Object = {'exact' : {'id' : pk}};
			new primaryDelegateClass(new PowerUResponder(onGetOneSuccess, onGetOneError, onFault)).getFiltered(loginProxy.authToken, filters, fields, getFilteredMethodName);
		}
		
		/*	get many from the backend based on filters.
			sends the updatedDataNotification with a DataSet containing the
			results sent back for this request only. */
		public function getFiltered(filters:Object, uid:String=null):void
		{
			var token:AsyncToken = new primaryDelegateClass(new PowerUResponder(onGetFilteredSuccess, onGetFilteredError, onFault)).getFiltered(loginProxy.authToken, filters, fields, getFilteredMethodName);
			token['filters'] = filters;
			if (uid != null)
				token['uid'] = uid;
		}
		
		/*	find records by IDs from local cache if possible, else from backend */
		public function findByIDs(ids:Array):void
		{
			var currentItems:Array = dataSet.findMembersByPK(ids).toArray();
			if (currentItems.length == ids.length)
				sendNotification(updatedDataNotification, new DataSet(currentItems));
			else
			{
				getFiltered({'member' : {'id' : ids}});
			}
		}
		
		/*	to use, set the following attributes on this instance:
			createArgNamesInOrder: an Array of argument names, in order, that are
				required for the create command.
		
			createOptionalArgNames: an Array of optional arguments to the create command
		*/
		public function create(argDict:Object, batchID:String=null):void
		{
			var args:Array = [loginProxy.authToken];
			for each (var argName:String in createArgNamesInOrder)
			{
				args.push(argDict[argName]);
			}
			
			if (createOptionalArgNames.length > 0)
			{
				var optional_args:Object = {};
				for each (var property:String in createOptionalArgNames)
				{
					if (argDict.hasOwnProperty(property))
						optional_args[property] = argDict[property];
				}
				args.push(optional_args);
			}
			
			var token:AsyncToken = new primaryDelegateClass(new PowerUResponder(onCreateSuccess, onCreateError, onFault)).create.apply(this, args);
			if (batchID != null)
				token.batchID = batchID;
		}
		
		public function createAsBatch(items:Array):void
		{
			createBatchTracker();
			batchTracker.totalRequests = items.length;
			for each (var item:Object in items)
			create(item, batchTracker.batchID);
		}
		
		public function deleteObject(pk:Number):void
		{
			new primaryDelegateClass(new PowerUResponder(onDeleteSuccess, onDeleteError, onFault)).deleteObject(loginProxy.authToken, pk);
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
			data = new DataSet();
			_haveData = false;
		}
		
		/*	get one record by ID, from local cache or from backend */
		public function findByPK(pk:Number):void
		{
			var ret:Object = ObjectUtil.copy(dataSet.findByPK(pk));
			if (ret == null)
				getOne(pk);
			else
				sendNotification(NotificationNames.RECEIVEDONE, ret, getProxyName());
		}
		
		/* 	for each field that has potential choices, get those choices and
			send NotificationNames.UPDATECHOICES with them */
		public function getChoices():void
		{
			if (fieldChoices != null)
				sendNotification(NotificationNames.UPDATECHOICES, fieldChoices, proxyName);
		}
		
		/*	Upload a file.  A single use auth token must be obtained from the
			server, which is why we use an input collector.*/ 
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
		
		protected function createBatchTracker():void
		{
			if (batchTracker != null)
				batchTracker.removeEventListener(Event.COMPLETE, onBatchComplete);
			batchTracker = new BatchRequestTracker();
			batchTracker.addEventListener(Event.COMPLETE, onBatchComplete);
		}
		
		protected function convertIncomingData(data:Array):void
		{
			for each (var item:Object in data)
			{
				// Convert ISO8601 strings to Date objects
				for each (var field:String in dateTimeFields)
				{
					applyConversionFunction(item, field, stringToDate);
				}
				markIfNotEditable(item);
			}
		}
		
		protected function markIfNotEditable(item:Object):void
		{
			// First see if the user is logged in as an org-dependent role
			if (LoginProxy.ORG_BASED_STATES.indexOf(loginProxy.applicationState) != -1)
			{
				if (item.hasOwnProperty('organization'))
				{
					var orgID:Number = item.organization as Number;
					if (orgID == 0 && item.organization.hasOwnProperty('id'))
						orgID = item.organization.id as Number;
					if (loginProxy.associatedOrgs.indexOf(orgID) == -1)
						item[Constants.NOT_EDITABLE_FIELD_NAME] = true;
				}
			}		
		}
		
		/*	fieldName can be a multi-tier path delimited by '.'  This method will
			descend into child Objects when a dotted fieldName is provided. For
			example, a field name of 'user.first_name' will look for an attribute
			'user' of item and then look for attribute 'first_name' on the user
			object. There can be as many levels specified as you like. */
		protected function applyConversionFunction(item:Object, fieldName:String, func:Function):void
		{
			var fieldNameArray:Array = fieldName.split('.');
			if (fieldNameArray.length > 1 && item.hasOwnProperty(fieldNameArray[0]))
				// recursively call myself with child item and sliced fieldName  
				applyConversionFunction(item[fieldNameArray[0]], fieldNameArray.slice(1).join('.'), func);
			else if (item.hasOwnProperty(fieldName))
				item[fieldName] = func(item[fieldName]);
		}
		
		protected function stringToDate(value:String):Date
		{
			var ret:Date = null;
			
			// DateUtil doesn't recognize valid ISO8601 strings that have only a date, so we have to handle those on our own.
			var re:RegExp = /(\d{4})-(\d{1,2})-(\d{1,2})$/;
			var result:Object = re.exec(value);
			if (value != null)
			{
				if (result != null && result['length'] == 4)
					// month is 0-based. day of month is 1-based.
					ret = new Date(result[1], result[2] - 1, result[3]);
				else
					ret = DateUtil.parseW3CDTF(value);
			}
			
			return ret;
		}
		
		protected function applyStateFilters(filter:Object):Object
		{
			return filter;
		}
		
		protected function notifyBatchCreateComplete(items:DataSet):void
		{
			var successItems:ArrayCollection = new ArrayCollection();
			var errorItems:ArrayCollection = new ArrayCollection();
			
			for each (var successPK:Number in batchTracker.successPKs)
			successItems.addItem(items.findByPK(successPK));
			for each (var errorPK:Number in batchTracker.errorPKs)
			errorItems.addItem(items.findByPK(errorPK));
			
			sendNotification(NotificationNames.BATCHCREATECOMPLETE, {'success':successItems.toArray(), 'error':errorItems.toArray()}, proxyName);
		}
		
		protected function getProxy(type:Class):BaseProxy
		{
			return (facade as ApplicationFacade).retrieveOrRegisterProxy(type) as BaseProxy;
		}
		
		
		// result handlers
		
		protected function onGetFilteredSuccess(data:ResultEvent):void
		{
			var value:Array = data.result.value as Array;
			convertIncomingData(value);
			
			dataSet.mergeData(value);
			_haveData = true;
			var filters:Object = data.token['filters'];
			var newDataSet:DataSet = new DataSet(value);
			sendNotification(updatedDataNotification, newDataSet, filters.toString());
			
			if (data.token.hasOwnProperty('uid') && data.token.uid == batchTracker.batchID)
				notifyBatchCreateComplete(newDataSet);
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
			var newPK:Number = data.token['updatedItem']['id'];
			getFiltered({'exact' : {'id' : newPK}});
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
		
		/*	For now, once an object is created, we then fetch that object.
			Eventually, we should probably just have the backend return the
			fields we want right here. */
		protected function onCreateSuccess(data:ResultEvent):void
		{
			var newPK:Number = data.result.value.id;
			if (data.token.hasOwnProperty('batchID') && data.token.batchID == batchTracker.batchID)
			{
				batchTracker.processSuccess(data.result.value, data.token.batchID);
			}
			else
			{
				getFiltered({'exact' : {'id' : newPK}});
			}
			sendNotification(NotificationNames.CREATESUCCESS, newPK, proxyName);
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
			// gets manager name
			var msg:String = 'fault: ' + info.token.message.destination;
			try
			{
				// trys to add method name
				msg = msg.concat('.', info.token.message['operation']);
			}
			catch (err:ReferenceError)
			{
				// We gave it a try. Just leave the method name off				
			}
			finally
			{
				trace(msg);
			}
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
			var value:Array = event.result.value as Array;
			convertIncomingData(value);
			var item:Object = value[0];
			dataSet.addOrReplace(item);
			sendNotification(NotificationNames.RECEIVEDONE, ObjectUtil.copy(item), getProxyName());
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
		
		protected function onSendEmailSuccess(event:ResultEvent):void
		{
			sendNotification(NotificationNames.EMAILSENT);
		}
		
		protected function onSendEmailError(event:ResultEvent):void
		{
			trace('error sending email');
			sendNotification(NotificationNames.EMAILSENDERROR);
		}
		
		protected function onBatchComplete(event:Event):void
		{
			var pks:Array = batchTracker.successPKs.toArray().concat(batchTracker.errorPKs.toArray());
			// update local cache
			getFiltered({'member' : {'id' : pks}}, batchTracker.batchID);
		}
	}
}