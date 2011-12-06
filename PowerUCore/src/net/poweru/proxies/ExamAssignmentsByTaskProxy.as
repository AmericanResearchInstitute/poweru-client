package net.poweru.proxies
{
	import net.poweru.NotificationNames;
	import net.poweru.delegates.AssignmentManagerDelegate;
	
	import org.puremvc.as3.interfaces.IProxy;
	
	public class ExamAssignmentsByTaskProxy extends BaseProxy implements IProxy
	{
		public static const NAME:String = 'ExamAssignmentsByTaskProxy';
		
		public function ExamAssignmentsByTaskProxy()
		{
			super(NAME, AssignmentManagerDelegate, NotificationNames.UPDATEEXAMASSIGNMENTSBYTASK, [], 'Assignment', []);
		}
	}
}