package net.poweru.presenters
{
	import mx.events.FlexEvent;
	
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.components.interfaces.IEvents;
	import net.poweru.events.ViewEvent;
	import net.poweru.model.DataSet;
	import net.poweru.proxies.EventProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class EventsMediator extends BaseMediator implements IMediator
	{
		public static const NAME:String = 'EventsMediator';
		
		public function EventsMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, EventProxy);
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
		}
		
		override protected function removeEventListeners():void
		{
			displayObject.removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);	
			displayObject.removeEventListener(ViewEvent.REFRESH, onRefresh);
			displayObject.removeEventListener(ViewEvent.SHOWDIALOG, onShowDialog);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				NotificationNames.SETSPACE,
				NotificationNames.UPDATEEVENTS,
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
					events.populate((notification.getBody() as DataSet).toArray());
					break;
			}
		}
		
		override protected function populate():void
		{
			primaryProxy.getAll();
		}
	}
}