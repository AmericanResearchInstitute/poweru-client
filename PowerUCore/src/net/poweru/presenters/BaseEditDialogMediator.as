package net.poweru.presenters
{
	import mx.events.FlexEvent;
	
	import net.poweru.NotificationNames;
	import net.poweru.components.interfaces.IEditDialog;
	import net.poweru.events.ViewEvent;
	import net.poweru.placemanager.InitialDataProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;

	public class BaseEditDialogMediator extends BaseMediator implements IMediator
	{
		protected var initialDataProxy:InitialDataProxy;
		protected var placeName:String;
		
		// placeName is the name associated with this dialog
		public function BaseEditDialogMediator(mediatorName:String, viewComponent:Object, primaryProxyClass:Class, placeName:String)
		{
			super(mediatorName, viewComponent, primaryProxyClass);
			initialDataProxy = facade.retrieveProxy(InitialDataProxy.NAME) as InitialDataProxy;
			
			this.placeName = placeName;
		}
		
		protected function get editDialog():IEditDialog
		{
			return viewComponent as IEditDialog;
		}
		
		override protected function addEventListeners():void
		{
			super.addEventListeners();
			if (displayObject)
			{
				displayObject.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
				displayObject.addEventListener(ViewEvent.SUBMIT, onSubmit);
				displayObject.addEventListener(ViewEvent.CANCEL, onCancel);
			}
		}
		
		override protected function removeEventListeners():void
		{
			super.addEventListeners();
			if (displayObject)
			{
				displayObject.removeEventListener(ViewEvent.SUBMIT, onSubmit);
				displayObject.removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
				displayObject.removeEventListener(ViewEvent.CANCEL, onCancel);
			}
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case NotificationNames.LOGOUT:
					if (editDialog)
						editDialog.clear();
					break;
				
				case NotificationNames.DIALOGPRESENTED:
					var body:String = notification.getBody() as String;
					if (body != null && body == placeName)
						populate();
					break;
			}
		}
		
		// probably override this in a subclass, and make sure to call the method on super()
		protected function onSubmit(event:ViewEvent):void
		{
			primaryProxy.save(editDialog.getData());
			sendNotification(NotificationNames.REMOVEDIALOG, displayObject);
		}
		
		// override this in a subclass, or at least listen for NotificationNames.RECEIVEDONE
		override protected function populate():void
		{
			primaryProxy.findByPK(initialDataProxy.getInitialData(placeName) as Number);
		}
		
		protected function onCancel(event:ViewEvent):void
		{
			sendNotification(NotificationNames.REMOVEDIALOG, displayObject);
		}
		
		// If this came from our primaryProxy, this will populate the editDialog
		protected function onReceivedOne(notification:INotification):void
		{
			var type:String = notification.getType();
			if (type == primaryProxy.getProxyName())
				editDialog.populate(notification.getBody() as Object);
		}
		
	}
}