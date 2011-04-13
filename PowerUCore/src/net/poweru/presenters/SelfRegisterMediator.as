package net.poweru.presenters
{
	import mx.controls.Alert;
	
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.components.interfaces.ISelfRegister;
	import net.poweru.events.ViewEvent;
	import net.poweru.presenters.BaseCreateDialogMediator;
	import net.poweru.proxies.UserProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;

	public class SelfRegisterMediator extends BaseCreateDialogMediator implements IMediator
	{
		public static const NAME:String = 'SelfRegisterMediator';
		
		public function SelfRegisterMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, UserProxy);
		}

		protected function get userProxy():UserProxy
		{
			return primaryProxy as UserProxy;
		}
		
		protected function get selfRegister():ISelfRegister
		{
			return viewComponent as ISelfRegister;
		}
		
		protected function populate():void
		{
			loginProxy.getCaptchaChallenge();
		}
		
		protected function onRefreshCaptcha(event:ViewEvent):void
		{
			populate();
		}
		
		override protected function onSubmit(event:ViewEvent):void
		{
			primaryProxy.create(createDialog.getData());
		}
		
		override protected function addEventListeners():void
		{
			super.addEventListeners();
			displayObject.addEventListener(ViewEvent.REFRESH, onRefreshCaptcha);
		}
		
		override protected function removeEventListeners():void
		{
			super.removeEventListeners();
			displayObject.removeEventListener(ViewEvent.REFRESH, onRefreshCaptcha);
		}

		override public function listNotificationInterests():Array
		{
			return [
				NotificationNames.CAPTCHACHALLENGE,
				NotificationNames.CREATEUSERSUCCESS,
				NotificationNames.CREATEUSERPERMISSIONDENIED,
				NotificationNames.DIALOGPRESENTED,
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var user:Object;

			switch (notification.getName())
			{
				case NotificationNames.CAPTCHACHALLENGE:
					var challengeInfo:Array = notification.getBody() as Array;
					selfRegister.setCaptchaChallenge.apply(selfRegister, challengeInfo);
					break;
				
				case NotificationNames.CREATEUSERSUCCESS:
					selfRegister.clear();
					sendNotification(NotificationNames.REMOVEDIALOG, selfRegister);
					Alert.show('You will receive a confirmation email with a link to activate your account.\n\nAn admin will confirm your organization membership.', 'Registration Complete');
					break;
				
				// Tell user that captcha failed and load a new challenge
				case NotificationNames.CREATEUSERPERMISSIONDENIED:
					Alert.show("CAPTCHA verification failed.  Please try again.");
					populate();
					break;
				
				case NotificationNames.DIALOGPRESENTED:
					var body:String = notification.getBody() as String;
					if (body != null && body == Places.SELFREGISTER)
						populate();
					break;
			}
		}
	}
}