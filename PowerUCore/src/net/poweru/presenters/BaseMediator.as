package net.poweru.presenters
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import mx.events.FlexEvent;
	
	import net.poweru.ApplicationFacade;
	import net.poweru.NotificationNames;
	import net.poweru.components.interfaces.IArrayPopulatedComponent;
	import net.poweru.components.interfaces.IClearableComponent;
	import net.poweru.components.interfaces.IObjectPopulatedComponent;
	import net.poweru.events.ViewEvent;
	import net.poweru.proxies.BaseProxy;
	import net.poweru.proxies.LoginProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class BaseMediator extends Mediator implements IMediator
	{
		protected var primaryProxy:BaseProxy;
		protected var loginProxy:LoginProxy;
		
		public function BaseMediator(mediatorName:String, viewComponent:Object, primaryProxyClass:Class=null)
		{
			super(mediatorName, viewComponent);
			
			if (primaryProxyClass)
				primaryProxy = (facade as ApplicationFacade).retrieveOrRegisterProxy(primaryProxyClass) as BaseProxy;
				
			loginProxy = (facade as ApplicationFacade).retrieveOrRegisterProxy(LoginProxy) as LoginProxy;
			
			if (viewComponent)
				addEventListeners();
		}
		
		protected function get displayObject():DisplayObject
		{
			return viewComponent as DisplayObject;
		}
		
		protected function get arrayPopulatedComponent():IArrayPopulatedComponent
		{
			return viewComponent as IArrayPopulatedComponent;
		}
		
		protected function get objectPopulatedComponent():IObjectPopulatedComponent
		{
			return viewComponent as IObjectPopulatedComponent;
		}
		
		protected function get clearableComponent():IClearableComponent
		{
			return viewComponent as IClearableComponent;
		}
		
		protected function addEventListeners():void
		{}
		
		protected function removeEventListeners():void
		{}
		
		protected function populate():void
		{}
		
		override public function listNotificationInterests():Array
		{
			return super.listNotificationInterests().concat(
				NotificationNames.LOGOUT,
				NotificationNames.STATECHANGE
			);
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case NotificationNames.LOGOUT:
					if (clearableComponent != null)
						clearableComponent.clear();
					break;
				
				case NotificationNames.STATECHANGE:
					if (viewComponent.hasOwnProperty('setState'))
						viewComponent.setState(notification.getBody());
					break;
				
				default:
					super.handleNotification(notification);
			}
		}
		
		override public function setViewComponent(viewComponent:Object):void
		{
			removeEventListeners();
			super.setViewComponent(viewComponent);
			addEventListeners();
		}
		
		protected function getProxy(type:Class):BaseProxy
		{
			return (facade as ApplicationFacade).retrieveOrRegisterProxy(type) as BaseProxy;
		}
		
		protected function onShowDialog(event:ViewEvent):void
		{
			sendNotification(NotificationNames.SHOWDIALOG, event.body);
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			displayObject.removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			populate();
			if (viewComponent.hasOwnProperty('setState'))
				viewComponent.setState(loginProxy.applicationState);
		}
		
		protected function onRefresh(event:ViewEvent):void
		{
			primaryProxy.clear();
			populate();
		}
		
	}
}