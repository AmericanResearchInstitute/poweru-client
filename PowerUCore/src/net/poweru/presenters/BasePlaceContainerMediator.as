package net.poweru.presenters
{
	import flash.display.DisplayObject;
	
	import mx.events.FlexEvent;
	
	import net.poweru.ApplicationFacade;
	import net.poweru.NotificationNames;
	import net.poweru.events.ViewEvent;
	import net.poweru.proxies.LoginProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	/*	Use this as the mediator for any container which either is or contains
		PlaceContainers. This mediator will automatically populate them with
		their requested place. */
	public class BasePlaceContainerMediator extends Mediator implements IMediator
	{
		protected var loginProxy:LoginProxy;
		
		public function BasePlaceContainerMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(mediatorName, viewComponent);
			init();
		}
		
		private function init():void
		{
			loginProxy = (facade as ApplicationFacade).retrieveOrRegisterProxy(LoginProxy) as LoginProxy;
			displayObject.addEventListener(ViewEvent.SETOTHERSPACE, onSetOtherSpace);
			displayObject.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		override public function listNotificationInterests():Array
		{
			return super.listNotificationInterests().concat(
				NotificationNames.STATECHANGE
			);
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case NotificationNames.STATECHANGE:
					if (viewComponent.hasOwnProperty('setState'))
						viewComponent.setState(loginProxy.applicationState);
					break;
				
				default:
					super.handleNotification(notification);
			}
		}
		
		protected function get displayObject():DisplayObject
		{
			return viewComponent as DisplayObject;
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			displayObject.removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			if (viewComponent.hasOwnProperty('setState'))
				viewComponent.setState(loginProxy.applicationState);
		}
		
		protected function onSetOtherSpace(event:ViewEvent):void
		{
			sendNotification(NotificationNames.SETOTHERSPACE, event.body, event.subType);
			event.stopPropagation();
		}
	}
}