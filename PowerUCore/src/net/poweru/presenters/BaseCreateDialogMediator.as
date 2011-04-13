package net.poweru.presenters
{
	import net.poweru.NotificationNames;
	import net.poweru.components.interfaces.ICreateDialog;
	import net.poweru.events.ViewEvent;
	
	import mx.events.FlexEvent;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;

	public class BaseCreateDialogMediator extends BaseMediator implements IMediator
	{
		protected var primaryProxyName:String;
		
		
		public function BaseCreateDialogMediator(mediatorName:String, viewComponent:Object, primaryProxyClass:Class)
		{
			super(mediatorName, viewComponent, primaryProxyClass);
			primaryProxyName = primaryProxyClass.NAME;
		}
		
		override protected function addEventListeners():void
		{
			displayObject.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			displayObject.addEventListener(ViewEvent.SUBMIT, onSubmit);
			displayObject.addEventListener(ViewEvent.CANCEL, onCancel);
		}
		
		override protected function removeEventListeners():void
		{
			displayObject.removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			displayObject.removeEventListener(ViewEvent.SUBMIT, onSubmit);
			displayObject.removeEventListener(ViewEvent.CANCEL, onCancel);
		}
		
		protected function get createDialog():ICreateDialog
		{
			return viewComponent as ICreateDialog;
		}
		
		protected function onSubmit(event:ViewEvent):void
		{
			primaryProxy.create(createDialog.getData());
			createDialog.clear();
			sendNotification(NotificationNames.REMOVEDIALOG, displayObject);
		}
		
		protected function onCancel(event:ViewEvent):void
		{
			sendNotification(NotificationNames.REMOVEDIALOG, displayObject);
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			displayObject.removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			primaryProxy.getChoices();
		}
		
		override public function setViewComponent(viewComponent:Object):void
		{
			super.setViewComponent(viewComponent);
			primaryProxy.getChoices();
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				NotificationNames.UPDATECHOICES,
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case NotificationNames.UPDATECHOICES:
					if (notification.getType() == primaryProxyName)
						createDialog.setChoices(notification.getBody());
					break;
			}
		}
	}
}