package net.poweru.presenters
{
	import net.poweru.NotificationNames;
	import net.poweru.events.ViewEvent;
	import net.poweru.presenters.BaseMediator;
	import net.poweru.proxies.LoginProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	
	public class ConfirmLogoutMediator extends BaseMediator implements IMediator
	{
		public static const NAME:String = "ConfirmLogoutMediator";
		
		public function ConfirmLogoutMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
		}

		override protected function addEventListeners():void
		{
			displayObject.addEventListener(ViewEvent.CONFIRM, onConfirm);
			displayObject.addEventListener(ViewEvent.CANCEL, onCancel);
		}
	
		override protected function removeEventListeners():void
		{
			displayObject.removeEventListener(ViewEvent.CONFIRM, onConfirm);
			displayObject.removeEventListener(ViewEvent.CANCEL, onCancel);
		}
		
		protected function onConfirm(event:ViewEvent):void
		{
			(facade.retrieveProxy(LoginProxy.NAME) as LoginProxy).logout();
			close();
		}
		
		protected function onCancel(event:ViewEvent):void
		{
			close();
		}
		
		protected function close():void
		{
			sendNotification(NotificationNames.REMOVEDIALOG, displayObject);
		}
	}
}