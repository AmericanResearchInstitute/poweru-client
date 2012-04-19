package net.poweru.commands
{
	import net.poweru.ApplicationFacade;
	import net.poweru.proxies.ExamProxy;
	import net.poweru.proxies.FileDownloadProxy;
	import net.poweru.proxies.SessionUserRoleRequirementProxy;
	import net.poweru.proxies.TaskProxy;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	/*	This exists so that when a subclass of Task is created, the Task proxy
		will have that item added to its local cache. */
	public class FetchNewTaskCommand extends SimpleCommand implements ICommand
	{
		protected static const TASK_PROXY_NAMES:Array = [
			ExamProxy.NAME,
			FileDownloadProxy.NAME,
			SessionUserRoleRequirementProxy.NAME
		];
		
		protected var taskProxy:TaskProxy;
		
		public function FetchNewTaskCommand()
		{
			super();
			taskProxy = (facade as ApplicationFacade).retrieveOrRegisterProxy(TaskProxy) as TaskProxy;
		}
		
		override public function execute(notification:INotification):void
		{
			if (TASK_PROXY_NAMES.indexOf(notification.getType()) != -1 && taskProxy.haveData)
			{
				var newPK:Number = notification.getBody() as Number;
				taskProxy.getFiltered({'exact' : {'id' : newPK}});
			}
		}
	}
}