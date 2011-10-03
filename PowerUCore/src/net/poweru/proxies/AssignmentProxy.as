package net.poweru.proxies
{
	import net.poweru.NotificationNames;
	import net.poweru.delegates.AssignmentManagerDelegate;
	
	import org.puremvc.as3.interfaces.IProxy;
	
	public class AssignmentProxy extends BaseProxy implements IProxy
	{
		public static const NAME:String = 'AssignmentProxy';
		public static const FIELDS:Array = ['task', 'user', 'status'];
		
		public function AssignmentProxy()
		{
			super(NAME, AssignmentManagerDelegate, NotificationNames.UPDATEASSIGNMENTS, FIELDS, 'Assignment');
			createArgNamesInOrder = ['task', 'user'];
		}
	}
}