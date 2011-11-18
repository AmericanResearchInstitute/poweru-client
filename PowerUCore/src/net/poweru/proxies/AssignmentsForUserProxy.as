package net.poweru.proxies
{
	import net.poweru.NotificationNames;
	import net.poweru.delegates.AssignmentManagerDelegate;
	
	import org.puremvc.as3.interfaces.IProxy;
	
	public class AssignmentsForUserProxy extends BaseProxy implements IProxy
	{
		public static const NAME:String = 'AssignmentsForUser';
		
		public function AssignmentsForUserProxy()
		{
			super(NAME, AssignmentManagerDelegate, NotificationNames.UPDATEASSIGNMENTSFORUSER, []);
			getFilteredMethodName = 'assignments_for_user';
		}
	}
}