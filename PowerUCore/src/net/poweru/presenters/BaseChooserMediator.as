package net.poweru.presenters
{
	import mx.events.FlexEvent;
	
	import net.poweru.ApplicationFacade;
	import net.poweru.NotificationNames;
	import net.poweru.components.dialogs.choosers.interfaces.IChooser;
	import net.poweru.events.ViewEvent;
	import net.poweru.model.ChooserRequest;
	import net.poweru.model.ChooserResult;
	import net.poweru.model.DataSet;
	import net.poweru.placemanager.InitialDataProxy;
	import net.poweru.utils.PKArrayCollection;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	/*	Base class for mediators that present an IChooser dialog. These
		are dialogs that are used to make a choice when a user is filling
		out a form, especially when the data from which to choose is not
		easily made available in something simple like a ComboBox.
	
		Pass an array of PKs to exclude into the InitialDataProxy. For
		example, you probably don't want to display choices that have already
		been selected.
	*/
	public class BaseChooserMediator extends BaseMediator implements IMediator
	{
		protected var placeName:String;
		protected var updateNotification:String;
		protected var request:ChooserRequest;
		protected var initialDataProxy:InitialDataProxy;
		
		public function BaseChooserMediator(mediatorName:String, viewComponent:Object, placeName:String, updateNotification:String, primaryProxyClass:Class=null)
		{
			super(mediatorName, viewComponent, primaryProxyClass);
			this.placeName = placeName; 
			this.updateNotification = updateNotification;
			initialDataProxy = (facade as ApplicationFacade).retrieveOrRegisterProxy(InitialDataProxy) as InitialDataProxy;
		}
		
		protected function get chooser():IChooser
		{
			return viewComponent as IChooser;
		}
		
		override protected function addEventListeners():void
		{
			displayObject.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			displayObject.addEventListener(ViewEvent.REFRESH, onRefresh);
			displayObject.addEventListener(ViewEvent.SUBMIT, onSubmit);
			displayObject.addEventListener(ViewEvent.CANCEL, onCancel);
		}
		
		override protected function removeEventListeners():void
		{
			displayObject.removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);	
			displayObject.removeEventListener(ViewEvent.REFRESH, onRefresh);
			displayObject.removeEventListener(ViewEvent.SUBMIT, onSubmit);
			displayObject.removeEventListener(ViewEvent.CANCEL, onCancel);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				NotificationNames.LOGOUT,
				NotificationNames.SHOWDIALOG,
				updateNotification
			];
		}
		
		override protected function populate():void
		{
			 retrieveRequest();
		}
		
		protected function retrieveRequest():void
		{
			request = initialDataProxy.getInitialData(placeName) as ChooserRequest;
		}
		
		protected function applyExcludes(data:Array):Array
		{
			var newData:DataSet = new DataSet(primaryProxy.dataSet.toArray());
			if (request != null)
			{
				if (request.exclude == null)
					request.exclude = [];
				for each (var pk:Number in new PKArrayCollection(request.exclude))
				newData.removeByPK(pk);
			}
			return newData.toArray();
		}
		
		protected function onSubmit(event:ViewEvent):void
		{
			sendNotification(NotificationNames.CHOICEMADE, new ChooserResult(request.requestID, event.body), placeName);
			sendNotification(NotificationNames.REMOVEDIALOG, displayObject);
			chooser.clear();
		}
		
		protected function onCancel(event:ViewEvent):void
		{
			sendNotification(NotificationNames.REMOVEDIALOG, displayObject);
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case NotificationNames.LOGOUT:
					chooser.clear();
					break;
				
				case NotificationNames.SHOWDIALOG:
					if (notification.getBody()[0] == placeName)
						chooser.clear();
						populate();
					break;
			}
		}
	}
}