package net.poweru.presenters
{
	import mx.events.FlexEvent;
	
	import net.poweru.ApplicationFacade;
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.components.interfaces.IEvents;
	import net.poweru.events.ViewEvent;
	import net.poweru.model.DataSet;
	import net.poweru.proxies.EventProxy;
	import net.poweru.proxies.SessionProxy;
	import net.poweru.proxies.SessionUserRoleRequirementProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class EventsMediator extends BaseMediator implements IMediator
	{
		public static const NAME:String = 'EventsMediator';
		
		protected var sessionProxy:SessionProxy;
		// We only need this so we can clear its cache when "Refresh" is clicked.
		protected var sessionUserRoleRequirementProxy:SessionUserRoleRequirementProxy;
		
		public function EventsMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, EventProxy);
			sessionProxy = (facade as ApplicationFacade).retrieveOrRegisterProxy(SessionProxy) as SessionProxy;
			sessionUserRoleRequirementProxy = (facade as ApplicationFacade).retrieveOrRegisterProxy(SessionUserRoleRequirementProxy) as SessionUserRoleRequirementProxy;
		}
		
		protected function get events():IEvents
		{
			return displayObject as IEvents;
		}
		
		override protected function addEventListeners():void
		{
			displayObject.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			displayObject.addEventListener(ViewEvent.REFRESH, onRefresh);
			displayObject.addEventListener(ViewEvent.SHOWDIALOG, onShowDialog);
			displayObject.addEventListener(ViewEvent.FETCH, onFetchSessions);
		}
		
		override protected function removeEventListeners():void
		{
			displayObject.removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);	
			displayObject.removeEventListener(ViewEvent.REFRESH, onRefresh);
			displayObject.removeEventListener(ViewEvent.SHOWDIALOG, onShowDialog);
			displayObject.removeEventListener(ViewEvent.FETCH, onFetchSessions);
		}
		
		override protected function onRefresh(event:ViewEvent):void
		{
			sessionProxy.clear();
			sessionUserRoleRequirementProxy.clear();
			super.onRefresh(event);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				NotificationNames.SETSPACE,
				NotificationNames.UPDATEEVENTS,
				NotificationNames.UPDATESESSIONS
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case NotificationNames.SETSPACE:
					if (notification.getBody() == Places.EVENTS)
						populate();
					break;
				
				// Happens when we save an Event, and indicates that we should just refresh the view
				case NotificationNames.UPDATEEVENTS:
					events.populate(primaryProxy.dataSet.toArray());
					break;
				
				case NotificationNames.UPDATESESSIONS:
					events.setSessions((notification.getBody() as DataSet).toArray());
					break;
			}
		}
		
		override protected function populate():void
		{
			primaryProxy.getAll();
		}
		
		protected function onFetchSessions(event:ViewEvent):void
		{
			var session_ids:Array = event.body as Array;
			if (session_ids.length > 0)
				sessionProxy.findByIDs(session_ids);
		}
	}
}