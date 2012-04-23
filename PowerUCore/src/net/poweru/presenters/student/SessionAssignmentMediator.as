package net.poweru.presenters.student
{
	import mx.events.FlexEvent;
	
	import net.poweru.Constants;
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.events.ViewEvent;
	import net.poweru.presenters.BaseMediator;
	import net.poweru.proxies.SessionAssignmentsForUserProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class SessionAssignmentMediator extends BaseMediator implements IMediator
	{
		public static const NAME:String = 'SessionAssignmentMediator';
		
		public function SessionAssignmentMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, SessionAssignmentsForUserProxy);
		}
		
		override protected function addEventListeners():void
		{
			displayObject.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			displayObject.addEventListener(ViewEvent.REFRESH, onRefresh);
			displayObject.addEventListener(ViewEvent.SHOWDIALOG, onShowDialog);
		}
		
		override protected function removeEventListeners():void
		{
			displayObject.removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);	
			displayObject.removeEventListener(ViewEvent.REFRESH, onRefresh);
			displayObject.removeEventListener(ViewEvent.SHOWDIALOG, onShowDialog);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				NotificationNames.SETSPACE,
				NotificationNames.UPDATESESSIONASSIGNMENTSFORUSER,
				NotificationNames.LOGOUT
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case NotificationNames.SETSPACE:
					if (notification.getBody() == Places.EXAMASSIGNMENTS)
						populate();
					break;
				
				case NotificationNames.UPDATESESSIONASSIGNMENTSFORUSER:
					arrayPopulatedComponent.populate(primaryProxy.dataSet.toArray());
					break;
				
				default:
					super.handleNotification(notification);
			}
		}
		
		override protected function populate():void
		{
			primaryProxy.getFiltered({'member': {'status' : Constants.ASSIGNMENT_INCOMPLETE_STATUSES}});
		}
	}
}