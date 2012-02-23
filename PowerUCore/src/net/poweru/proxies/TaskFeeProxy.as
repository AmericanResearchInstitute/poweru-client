package net.poweru.proxies
{
	import mx.rpc.events.ResultEvent;
	
	import net.poweru.NotificationNames;
	import net.poweru.delegates.TaskFeeManagerDelegate;
	
	import org.puremvc.as3.interfaces.IProxy;
	
	public class TaskFeeProxy extends BaseProxy implements IProxy
	{
		public static const NAME:String = 'TaskFeeProxy';
		public static const FIELDS:Array= ['name', 'description', 'task'];
		
		public function TaskFeeProxy()
		{
			super(NAME, TaskFeeManagerDelegate, updatedDataNotification, FIELDS, 'TaskFee');
			createArgNamesInOrder = ['sku', 'name', 'description', 'price', 'task'];
		}
		
		override protected function onCreateSuccess(data:ResultEvent):void
		{
			sendNotification(NotificationNames.TASKFEECREATED);
		}
		
		override protected function onDeleteSuccess(data:ResultEvent):void
		{
			sendNotification(NotificationNames.TASKFEEDELETED);
		}
	}
}