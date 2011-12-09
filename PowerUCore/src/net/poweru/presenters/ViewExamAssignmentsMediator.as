package net.poweru.presenters
{
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.model.DataSet;
	import net.poweru.placemanager.PlaceNotFound;
	import net.poweru.proxies.ExamAssignmentsDetailProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class ViewExamAssignmentsMediator extends BaseReportDialogMediator implements IMediator
	{
		public static const NAME:String = 'ViewExamAssignmentsMediator';
		
		public function ViewExamAssignmentsMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, ExamAssignmentsDetailProxy);
		}
		
		override protected function populate():void
		{
			
			var examPK:Number = initialDataProxy.getInitialData(Places.VIEWEXAMASSIGNMENTS) as Number;
			primaryProxy.getFiltered({'exact' : {'task' : examPK}});
		}
		
		override public function listNotificationInterests():Array
		{
			var ret:Array = super.listNotificationInterests();
			ret.push(
				NotificationNames.UPDATEEXAMASSIGNMENTSDETAIL,
				NotificationNames.LOGOUT,
				NotificationNames.DIALOGPRESENTED
			);
			return ret;
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case NotificationNames.LOGOUT:
					reportDialog.clear();
					break;
					
				case NotificationNames.DIALOGPRESENTED:
					if (notification.getBody() == Places.VIEWEXAMASSIGNMENTS)
					{
						reportDialog.clear();
						populate();
					}
					break;
					
				case NotificationNames.UPDATEEXAMASSIGNMENTSDETAIL:
					reportDialog.populate((notification.getBody() as DataSet).toArray());
					break;
				
				default:
					super.handleNotification(notification);
			}
		}
	}
}