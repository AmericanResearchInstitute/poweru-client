package net.poweru.proxies
{
	import net.poweru.NotificationNames;
	import net.poweru.delegates.AssignmentManagerDelegate;
	import net.poweru.delegates.SessionUserRoleRequirementManagerDelegate;
	
	import org.puremvc.as3.interfaces.IProxy;
	
	public class SessionAssignmentsForUserProxy extends BaseProxy implements IProxy
	{
		public static const NAME:String = 'SessionAssignmentsForUserProxy';
		
		public function SessionAssignmentsForUserProxy()
		{
			super(NAME, AssignmentManagerDelegate, NotificationNames.UPDATESESSIONASSIGNMENTSFORUSER, [], 'Assignment', []);
			getFilteredMethodName = 'session_assignments_for_user';
			dateTimeFields = ['task.session.start', 'task.session.end'];
		}
	}
}