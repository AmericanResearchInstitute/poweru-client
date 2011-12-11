package net.poweru.proxies
{
	import mx.rpc.events.ResultEvent;
	
	import net.poweru.NotificationNames;
	import net.poweru.delegates.AssignmentManagerDelegate;
	import net.poweru.utils.PowerUResponder;
	
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
		
		public function bulkCreate(taskID:Number, userIDs:Array):void
		{
			new AssignmentManagerDelegate(new PowerUResponder(onBulkCreateSuccess, onBulkCreateFailure, onFault)).bulkCreate(loginProxy.authToken, taskID, userIDs);
		}
		
		protected function onBulkCreateSuccess(event:ResultEvent):void
		{
			// This will trigger BulkAssignmentResultsCommand
			sendNotification(NotificationNames.BULKASSIGNSUCCESS, event.result.value);
		}
		
		protected function onBulkCreateFailure(event:ResultEvent):void
		{
			trace('bulk assignment failure');
		}
	}
}