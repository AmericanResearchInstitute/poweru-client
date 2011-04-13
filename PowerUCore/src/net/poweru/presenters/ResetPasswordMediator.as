package net.poweru.presenters
{
	import mx.controls.Alert;
	import mx.events.FlexEvent;
	
	import net.poweru.ApplicationFacade;
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.components.interfaces.IResetPassword;
	import net.poweru.events.ViewEvent;
	import net.poweru.placemanager.InitialDataProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;

	public class ResetPasswordMediator extends BaseMediator implements IMediator
	{
		public static const NAME:String = 'ResetPasswordMediator';
		
		protected var initialDataProxy:InitialDataProxy;
		
		public function ResetPasswordMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, null);
			initialDataProxy = (facade as ApplicationFacade).retrieveOrRegisterProxy(InitialDataProxy) as InitialDataProxy;
		}
		
		protected function get resetPassword():IResetPassword
		{
			return viewComponent as IResetPassword;
		}
		
		override protected function addEventListeners():void
		{
			displayObject.addEventListener(ViewEvent.CANCEL, onCancel);
			displayObject.addEventListener(ViewEvent.SUBMIT, onSubmit);
			displayObject.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		override protected function removeEventListeners():void
		{
			displayObject.removeEventListener(ViewEvent.CANCEL, onCancel);
			displayObject.removeEventListener(ViewEvent.SUBMIT, onSubmit);
			displayObject.removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		protected function onSubmit(event:ViewEvent):void
		{
			loginProxy.resetPassword(event.body[0], event.body[1]);
			sendNotification(NotificationNames.REMOVEDIALOG, displayObject);
		}
		
		protected function onCancel(event:ViewEvent):void
		{
			sendNotification(NotificationNames.REMOVEDIALOG, displayObject);
		}
		
		protected function populate():void
		{
			var initialData:String = initialDataProxy.getInitialData(Places.RESETPASSWORD) as String;
			resetPassword.populate(initialData);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				NotificationNames.DIALOGPRESENTED,
				NotificationNames.LOGOUT,
				NotificationNames.RESETPASSWORDFAILURE,
				NotificationNames.RESETPASSWORDSUCCESS,
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case NotificationNames.LOGOUT:
					resetPassword.clear();
					break;
				
				case NotificationNames.DIALOGPRESENTED:
					var body1:String = notification.getBody() as String;
					if (body1 != null && body1 == Places.RESETPASSWORD && resetPassword != null)
						populate();
					break;
				
				case NotificationNames.RESETPASSWORDFAILURE:
					Alert.show('Password reset failed. User not found', 'Reset Failed');
					break;

				case NotificationNames.RESETPASSWORDSUCCESS:
					Alert.show('Your new password has been emailed to you.', 'Password Reset Successful');
					break;
			}
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			displayObject.removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			populate();
		}
		
	}
}