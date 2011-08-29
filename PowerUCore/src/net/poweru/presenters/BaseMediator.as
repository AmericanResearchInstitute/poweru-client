package net.poweru.presenters
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import mx.events.FlexEvent;
	
	import net.poweru.ApplicationFacade;
	import net.poweru.NotificationNames;
	import net.poweru.events.ViewEvent;
	import net.poweru.proxies.BaseProxy;
	import net.poweru.proxies.LoginProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
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
		
		protected function addEventListeners():void
		{}
		
		protected function removeEventListeners():void
		{}
		
		protected function populate():void
		{}
		
		override public function setViewComponent(viewComponent:Object):void
		{
			removeEventListeners();
			super.setViewComponent(viewComponent);
			addEventListeners();
		}
		
		protected function onShowDialog(event:ViewEvent):void
		{
			sendNotification(NotificationNames.SHOWDIALOG, event.body);
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			displayObject.removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			populate();
		}
		
		protected function onRefresh(event:ViewEvent):void
		{
			primaryProxy.clear();
			populate();
		}
		
	}
}