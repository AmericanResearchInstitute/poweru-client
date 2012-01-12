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
		
		protected var outstandingBulkRequests:Number = 0;
		protected var queuedBulkResults:Array = [];
		
		public function AssignmentProxy()
		{
			super(NAME, AssignmentManagerDelegate, NotificationNames.UPDATEASSIGNMENTS, FIELDS, 'Assignment');
			createArgNamesInOrder = ['task', 'user'];
		}
		
		public function bulkCreate(taskID:Number, userIDs:Array):void
		{
			incrementOutstandingRequestCounter();
			new AssignmentManagerDelegate(new PowerUResponder(onBulkCreateSuccess, onBulkCreateFailure, onFault)).bulkCreate(loginProxy.authToken, taskID, userIDs);
		}
		
		protected function incrementOutstandingRequestCounter():void
		{
			outstandingBulkRequests += 1;
		}
		
		protected function onBulkCreateSuccess(event:ResultEvent):void
		{
			queuedBulkResults.push(event.result.value);
			if (queuedBulkResults.length >= outstandingBulkRequests)
			{
				// This will trigger BulkAssignmentResultsCommand
				sendNotification(NotificationNames.BULKASSIGNSUCCESS, queuedBulkResults);
				queuedBulkResults = [];
				outstandingBulkRequests = 0;
			}
		}
		
		protected function onBulkCreateFailure(event:ResultEvent):void
		{
			if (outstandingBulkRequests > 0)
				outstandingBulkRequests -= 1;
			trace('bulk assignment failure');
		}
	}
}