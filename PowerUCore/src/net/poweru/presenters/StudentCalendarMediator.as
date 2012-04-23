package net.poweru.presenters
{
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.proxies.SessionAssignmentsForUserProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class StudentCalendarMediator extends BaseCalendarDialogMediator implements IMediator
	{
		public static const NAME:String = 'StudentCalendarMediator';
		
		public function StudentCalendarMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, SessionAssignmentsForUserProxy);
		}

		override public function listNotificationInterests():Array
		{
			var ret:Array = super.listNotificationInterests();
			ret = ret.concat(
				NotificationNames.DIALOGPRESENTED,
				NotificationNames.UPDATESESSIONASSIGNMENTSFORUSER
			);
			return ret;
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case NotificationNames.DIALOGPRESENTED:
					if (notification.getBody() == Places.STUDENTCALENDAR)
						calendarDialog.clear();
					populate();
					break;
				
				case NotificationNames.UPDATESESSIONASSIGNMENTSFORUSER:
					calendarDialog.populate(primaryProxy.dataSet.toArray());
					break;
				
				default:
					return super.handleNotification(notification);
			}
		}
		
		override protected function populate():void
		{
			primaryProxy.getAll();
		}
	}
}