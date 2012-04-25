package net.poweru.presenters
{
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.proxies.OrgEnrolledSessionProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class OrgEnrolledSessionsMediator extends BaseCalendarDialogMediator implements IMediator
	{
		public static const NAME:String = 'OrgEnrolledSessionsMediator';
		
		public function OrgEnrolledSessionsMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, OrgEnrolledSessionProxy);
			init();
		}
		
		private function init():void
		{
			placeName = Places.ORGENROLLEDSESSIONS;
		}
		
		override public function listNotificationInterests():Array
		{
			return super.listNotificationInterests().concat(
				NotificationNames.UPDATEORGENROLLEDSESSIONS
			);
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case NotificationNames.UPDATEORGENROLLEDSESSIONS:
					calendarDialog.clear();
					calendarDialog.populate(primaryProxy.dataSet.toArray());
					break;
				
				default:
					return super.handleNotification(notification);
			}
		}
	}
}