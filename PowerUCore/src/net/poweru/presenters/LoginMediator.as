package net.poweru.presenters
{
	import flash.display.DisplayObject;
	
	import net.poweru.NotificationNames;
	import net.poweru.components.interfaces.ILogin;
	import net.poweru.events.ViewEvent;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;

	public class LoginMediator extends BaseMediator implements IMediator
	{
		public static const NAME:String = 'LoginMediator';
		
		public function LoginMediator(viewComponent:DisplayObject)
		{
			super(NAME, viewComponent);
		}
		
		override protected function addEventListeners():void
		{
			if (displayObject)
			{
				displayObject.addEventListener(ViewEvent.SUBMIT, onSubmit);
				displayObject.addEventListener(ViewEvent.SHOWDIALOG, onShowDialog);
			}
		}
		
		override protected function removeEventListeners():void
		{
			if (displayObject)
			{
				displayObject.removeEventListener(ViewEvent.SUBMIT, onSubmit);
				displayObject.removeEventListener(ViewEvent.SHOWDIALOG, onShowDialog);
			}
		}
		
		protected function get login():ILogin
		{
			return viewComponent as ILogin;
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				NotificationNames.LOGINFAILURE,
				NotificationNames.LOGINSUCCESS,
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case NotificationNames.LOGINFAILURE:
					login.setControlEnabledness(true);
					break;
					
				case NotificationNames.LOGINSUCCESS:
					login.clearPassword();
					login.setControlEnabledness(true);
					break;
			}
		}
		
		protected function onSubmit(event:ViewEvent):void
		{
			login.setControlEnabledness(false);
			var credentials:Array = login.getCredentials();
			loginProxy.login(credentials[0], credentials[1]);
		}
		
	}
}