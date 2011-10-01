package net.poweru.presenters
{
	import mx.events.FlexEvent;
	
	import net.poweru.ApplicationFacade;
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.components.interfaces.IEventTemplates;
	import net.poweru.events.ViewEvent;
	import net.poweru.model.DataSet;
	import net.poweru.proxies.EventTemplateProxy;
	import net.poweru.proxies.SessionTemplateProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class EventTemplatesMediator extends BaseMediator implements IMediator
	{
		public static const NAME:String = 'EventTemplatesMediator';
		
		protected var sessionTemplateProxy:SessionTemplateProxy;
		
		public function EventTemplatesMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, EventTemplateProxy);
			sessionTemplateProxy = (facade as ApplicationFacade).retrieveOrRegisterProxy(SessionTemplateProxy) as SessionTemplateProxy;
		}
		
		protected function get eventTemplates():IEventTemplates
		{
			return displayObject as IEventTemplates;
		}
		
		override protected function addEventListeners():void
		{
			displayObject.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			displayObject.addEventListener(ViewEvent.REFRESH, onRefresh);
			displayObject.addEventListener(ViewEvent.SHOWDIALOG, onShowDialog);
			displayObject.addEventListener(ViewEvent.FETCH, onFetchSessionTemplates);
		}
		
		override protected function removeEventListeners():void
		{
			displayObject.removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);	
			displayObject.removeEventListener(ViewEvent.REFRESH, onRefresh);
			displayObject.removeEventListener(ViewEvent.SHOWDIALOG, onShowDialog);
			displayObject.removeEventListener(ViewEvent.FETCH, onFetchSessionTemplates);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				NotificationNames.SETSPACE,
				NotificationNames.UPDATESESSIONTEMPLATES,
				NotificationNames.UPDATEEVENTTEMPLATES,
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case NotificationNames.SETSPACE:
					if (notification.getBody() == Places.EVENTTEMPLATES)
						populate();
					break;
				
				// Happens when we save an EventTemplate, and indicates that we should just refresh the view
				case NotificationNames.UPDATEEVENTTEMPLATES:
					eventTemplates.populate((notification.getBody() as DataSet).toArray());
					break;
				
				case NotificationNames.UPDATESESSIONTEMPLATES:
					eventTemplates.setSessionTemplates((notification.getBody() as DataSet).toArray());
					break;
			}
		}
		
		override protected function populate():void
		{
			primaryProxy.getAll();
		}
		
		protected function onFetchSessionTemplates(event:ViewEvent):void
		{
			var session_template_ids:Array = event.body as Array;
			if (session_template_ids.length > 0)
				sessionTemplateProxy.findByIDs(session_template_ids);
		}
	}
}