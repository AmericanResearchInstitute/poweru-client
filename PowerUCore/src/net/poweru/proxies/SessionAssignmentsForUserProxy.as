package net.poweru.proxies
{
	import net.poweru.NotificationNames;
	import net.poweru.delegates.AssignmentManagerDelegate;
	
	import org.puremvc.as3.interfaces.IProxy;
	
	public class SessionAssignmentsForUserProxy extends BaseProxy implements IProxy
	{
		public static const NAME:String = 'SessionAssignmentsForUserProxy';
		
		public function SessionAssignmentsForUserProxy()
		{
			super(NAME, AssignmentManagerDelegate, NotificationNames.UPDATESESSIONASSIGNMENTSFORUSER, [], 'Assignment', []);
			init();
		}
		
		private function init():void
		{
			getFilteredMethodName = 'session_view';
			dateTimeFields = ['task.session.start', 'task.session.end'];
		}
	}
}