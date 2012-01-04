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
				displayObject.addEventListener(ViewEvent.SHOWDIALOG, onShowDialog);
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
				displayObject.removeEventListener(ViewEvent.SHOWDIALOG, onShowDialog);
			}
		}
		
		override public function listNotificationInterests():Array
		{
			var ret:Array = super.listNotificationInterests();
			ret.push(NotificationNames.CHOICEMADE);
			ret.push(NotificationNames.DIALOGPRESENTED);
			ret.push(NotificationNames.LOGOUT);
			ret.push(NotificationNames.RECEIVEDONE);
			return ret;
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case NotificationNames.CHOICEMADE:
					// let the dialog decide if it is interested in this particular choice type
					editDialog.receiveChoice(notification.getBody(), notification.getType());
					break;
				
				case NotificationNames.LOGOUT:
					if (editDialog)
						editDialog.clear();
					break;
				
				case NotificationNames.DIALOGPRESENTED:
					var body:String = notification.getBody() as String;
					if (body != null && body == placeName)
						populate();
					break;
				
				case NotificationNames.RECEIVEDONE:
					var type:String = notification.getType();
					if (type == primaryProxy.getProxyName())
						onReceivedOne(notification);
					break;
			}
		}
		
		// probably override this in a subclass, and make sure to call the method on super()
		protected function onSubmit(event:ViewEvent):void
		{
			primaryProxy.save(editDialog.getData());
			sendNotification(NotificationNames.REMOVEDIALOG, displayObject);
			editDialog.clear();
		}
		
		// override this in a subclass, or at least listen for NotificationNames.RECEIVEDONE
		override protected function populate():void
		{
			editDialog.clear();
			primaryProxy.findByPK(initialDataProxy.getInitialData(placeName) as Number);
		}
		
		protected function onCancel(event:ViewEvent):void
		{
			sendNotification(NotificationNames.REMOVEDIALOG, displayObject);
			editDialog.clear();
		}
		
		/*	If this came from our primaryProxy, this will populate the editDialog
			This only gets called if the sending proxy matched out primaryProxy. */
		protected function onReceivedOne(notification:INotification):void
		{
			editDialog.populate(notification.getBody() as Object);
		}
		
	}
}