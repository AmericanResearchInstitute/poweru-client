package net.poweru.presenters
{
	import flash.display.DisplayObject;
	
	import mx.events.FlexEvent;
	
	import net.poweru.ComponentFactory;
	import net.poweru.NotificationNames;
	import net.poweru.components.interfaces.IMain;
	import net.poweru.events.ViewEvent;
	import net.poweru.placemanager.SpaceMediator;
	import net.poweru.proxies.LoginProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;

	public class MainMediator extends BaseMediator implements IMediator
	{
		public static const NAME:String = 'MainMediator';
		
		public function MainMediator(viewComponent:DisplayObject)
		{
			super(NAME, viewComponent);
		}
		
		override protected function addEventListeners():void
		{
			var component:DisplayObject = viewComponent as DisplayObject;
			if (component)
			{
				component.addEventListener(FlexEvent.CREATION_COMPLETE, onMainCreationComplete);
				component.addEventListener(ViewEvent.SETSPACE, onSetSpace);
				component.addEventListener(ViewEvent.SHOWDIALOG, onShowDialog);
				component.addEventListener(ViewEvent.LOGOUT, onLogout);
			}
		}
		
		override protected function removeEventListeners():void
		{
			var component:DisplayObject = viewComponent as DisplayObject;
				if (component)
				{
					component.removeEventListener(FlexEvent.CREATION_COMPLETE, onMainCreationComplete);
					component.removeEventListener(ViewEvent.SETSPACE, onSetSpace);
					component.removeEventListener(ViewEvent.SHOWDIALOG, onShowDialog);
					component.removeEventListener(ViewEvent.LOGOUT, onLogout);
				}
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				NotificationNames.LOGINSUCCESS,
				NotificationNames.LOGOUT,
				NotificationNames.PASSWORDCHANGESUCCESS,
				NotificationNames.STATECHANGE
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case NotificationNames.LOGINSUCCESS:
					main.setButtonBoxVisibility(true);
					break;
					
				case NotificationNames.LOGOUT:
					main.setButtonBoxVisibility(false);
					break;
					
				case NotificationNames.PASSWORDCHANGESUCCESS:
					main.passwordChangeSuccess();
					break;
					
				case NotificationNames.STATECHANGE:
					main.changeState(notification.getBody() as String);
					break;
			}
		}
		
		protected function get main():IMain
		{
			return viewComponent as IMain;
		}
		
		protected function onSetSpace(event:ViewEvent):void
		{
			sendNotification(NotificationNames.SETSPACE, event.body as String);
		}
		
		protected function onLogout(event:ViewEvent):void
		{
			(facade.retrieveProxy(LoginProxy.NAME) as LoginProxy).logout();
		}
		
		// Once the space has been created, fire up the space manager
		protected function onMainCreationComplete(event:FlexEvent):void
		{
			(viewComponent as DisplayObject).removeEventListener(FlexEvent.CREATION_COMPLETE, onMainCreationComplete);
			/*	Getting the instance of ComponentFactory like this should be ok, even though it probably
				isn't the most downcasted version of the class.  The most downcasted version should get
				instantiated by the app before this happens, so the correct version will be obtained here. */
			facade.registerMediator(new SpaceMediator(main.getSpace(), ComponentFactory.getInstance()));
		}
	}
}
