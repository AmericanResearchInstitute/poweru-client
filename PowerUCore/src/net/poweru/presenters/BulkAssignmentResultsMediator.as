package net.poweru.presenters
{
	import flash.events.Event;
	
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.proxies.AdminUsersViewProxy;
	import net.poweru.utils.InputCollector;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class BulkAssignmentResultsMediator extends BaseReportDialogMediator implements IMediator
	{
		public static const NAME:String = 'BulkAssignmentResultsMediator';
		
		public function BulkAssignmentResultsMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, AdminUsersViewProxy, Places.BULKASSIGNMENTRESULTS);
		}
		
		override public function listNotificationInterests():Array
		{
			var ret:Array = super.listNotificationInterests();
			ret = ret.concat([
				NotificationNames.RECEIVEDONE
			]);
			return ret;
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case NotificationNames.RECEIVEDONE:
					if (inputCollector != null && notification.getType() == primaryProxy.getProxyName())
					{
						var user:Object = notification.getBody();
						inputCollector.addInput(user['id'], user);
					}
					break;
				
				default:
					super.handleNotification(notification);
			}
		}
		
		override protected function populate():void
		{
			var requirements:Array = [];
			requirements.push('raw_results');
			
			var rawResults:Array = initialDataProxy.getInitialData(placeName) as Array;

			// Get all user PKs out of the result set
			var userIDs:Array = [];
			for each (var resultSet:Object in rawResults)
			{
				for (var userID:String in resultSet)
				{
					if (userIDs.indexOf(userID) == -1)
						userIDs.push(userID);
				}
			}
			
			requirements = requirements.concat(userIDs);
			
			if (inputCollector != null)
				inputCollector.removeEventListener(Event.COMPLETE, onInputsCollected);
			inputCollector = new InputCollector(requirements);
			inputCollector.addEventListener(Event.COMPLETE, onInputsCollected);
			
			inputCollector.addInput('raw_results', rawResults);
			
			/*	These should already be cached in the proxy following the
				assignment workflow. */
			for each (var userID2:String in userIDs)
				primaryProxy.findByPK(Number(userID2));
		}
		
		override protected function onInputsCollected(event:Event):void
		{
			var data:Array = [];
			var inputCollector:InputCollector = event.target as InputCollector;
			
			for each (var resultSet:Object in inputCollector.object['raw_results'])
			{
				var resultArray:Array = [];
				for (var userID:String in resultSet)
				{
					var user:Object = inputCollector.object[userID];
					user['assignmentStatus'] = resultSet[userID]['status']; 
					resultArray.push(user);
				}
				data.push(resultArray);
			}
			arrayPopulatedComponent.populate(data);
		}
	}
}