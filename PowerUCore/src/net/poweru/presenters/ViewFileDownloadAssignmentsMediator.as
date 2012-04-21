package net.poweru.presenters
{
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.model.DataSet;
	import net.poweru.proxies.FileDownloadAssignmentsDetailProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class ViewFileDownloadAssignmentsMediator extends BaseReportDialogMediator implements IMediator
	{
		public static const NAME:String = 'ViewFileDownloadAssignmentsMediator';
		
		public function ViewFileDownloadAssignmentsMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, FileDownloadAssignmentsDetailProxy);
		}
		
		override protected function populate():void
		{
			var taskPK:Number = initialDataProxy.getInitialData(Places.VIEWFILEDOWNLOADASSIGNMENTS) as Number;
			primaryProxy.getFiltered({'exact' : {'task' : taskPK}});
		}
		
		override public function listNotificationInterests():Array
		{
			return super.listNotificationInterests().concat(
				NotificationNames.UPDATEFILEDOWNLOADASSIGNMENTSDETAIL,
				NotificationNames.LOGOUT,
				NotificationNames.DIALOGPRESENTED
			);
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case NotificationNames.LOGOUT:
					arrayPopulatedComponent.clear();
					break;
				
				case NotificationNames.DIALOGPRESENTED:
					if (notification.getBody() == Places.VIEWFILEDOWNLOADASSIGNMENTS)
					{
						arrayPopulatedComponent.clear();
						populate();
					}
					break;
				
				case NotificationNames.UPDATEFILEDOWNLOADASSIGNMENTSDETAIL:
					arrayPopulatedComponent.populate((notification.getBody() as DataSet).toArray());
					break;
				
				default:
					super.handleNotification(notification);
			}
		}
	}
}