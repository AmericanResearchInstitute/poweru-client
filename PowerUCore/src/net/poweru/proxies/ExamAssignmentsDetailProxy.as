package net.poweru.proxies
{
	import net.poweru.NotificationNames;
	import net.poweru.delegates.AssignmentManagerDelegate;
	
	import org.puremvc.as3.interfaces.IProxy;
	
	// adds details for user and task attributes
	public class ExamAssignmentsDetailProxy extends BaseProxy implements IProxy
	{
		public static const NAME:String = 'ExamAssignmentsDetailProxy';
		
		public function ExamAssignmentsDetailProxy()
		{
			super(NAME, AssignmentManagerDelegate, NotificationNames.UPDATEEXAMASSIGNMENTSDETAIL, [], 'Assignment', []);
			init();
		}
		
		private function init():void
		{
			getFilteredMethodName = 'detailed_exam_view';
		}
	}
}