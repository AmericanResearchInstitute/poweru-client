package net.poweru.presenters
{
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.proxies.SessionProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class EventCalendarMediator extends BaseCalendarDialogMediator implements IMediator
	{
		public static const NAME:String = 'EventCalendarMediator';
		
		public function EventCalendarMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, SessionProxy);
			init();
		}
		
		private function init():void
		{
			placeName = Places.EVENTCALENDAR;
		}
		
		override public function listNotificationInterests():Array
		{
			return super.listNotificationInterests().concat(
				NotificationNames.UPDATESESSIONS
			);
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case NotificationNames.UPDATESESSIONS:
					calendarDialog.populate(primaryProxy.dataSet.toArray());
					break;
				
				default:
					return super.handleNotification(notification);
			}
		}
	}
}