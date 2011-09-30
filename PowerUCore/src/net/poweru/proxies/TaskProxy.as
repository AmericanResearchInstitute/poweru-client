package net.poweru.proxies
{
	import net.poweru.NotificationNames;
	import net.poweru.delegates.TaskManagerDelegate;
	
	import org.puremvc.as3.interfaces.IProxy;
	
	public class TaskProxy extends BaseProxy implements IProxy
	{
		public static const NAME:String = 'TaskProxy';
		public static const FIELDS:Array = ['name', 'title', 'description', 'type'];
		
		public function TaskProxy()
		{
			super(NAME, TaskManagerDelegate, NotificationNames.UPDATETASKS, FIELDS);
		}
	}
}