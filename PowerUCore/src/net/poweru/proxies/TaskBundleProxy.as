package net.poweru.proxies
{
	import net.poweru.NotificationNames;
	import net.poweru.delegates.TaskBundleManagerDelegate;
	
	import org.puremvc.as3.interfaces.IProxy;
	
	public class TaskBundleProxy extends BaseProxy implements IProxy
	{
		public static const NAME:String = 'TaskBundleProxy';
		
		public function TaskBundleProxy()
		{
			super(NAME, TaskBundleManagerDelegate, NotificationNames.UPDATETASKBUNDLESS, [], 'TaskBundle', []);
			init();
		}
		
		private function init():void
		{
			createArgNamesInOrder = ['name', 'description'];
			getFilteredMethodName = 'task_detail_view';
		}
	}
}