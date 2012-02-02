package net.poweru.proxies
{
	import net.poweru.NotificationNames;
	import net.poweru.delegates.AssignmentManagerDelegate;
	
	import org.puremvc.as3.interfaces.IProxy;
	
	public class ExamAssignmentsForUserProxy extends BaseProxy implements IProxy
	{
		public static const NAME:String = 'ExamAssignmentsForUserProxy';
		
		public function ExamAssignmentsForUserProxy()
		{
			super(NAME, AssignmentManagerDelegate, NotificationNames.UPDATEEXAMASSIGNMENTSFORUSER, [], 'Exam');
			getFilteredMethodName = 'exam_view';
		}
	}
}