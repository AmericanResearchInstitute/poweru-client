package net.poweru.presenters.student
{
	import mx.events.FlexEvent;
	
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.components.student.interfaces.IAssignments;
	import net.poweru.events.ViewEvent;
	import net.poweru.presenters.BaseMediator;
	import net.poweru.proxies.AssignmentsForUserProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class AssignmentsMediator extends BaseMediator implements IMediator
	{
		public static const NAME:String = 'StudentAssignmentsMediator';
		
		public function AssignmentsMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, AssignmentsForUserProxy);
		}
		
		protected function get assignments():IAssignments
		{
			return displayObject as IAssignments;
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
				NotificationNames.UPDATEASSIGNMENTSFORUSER,
				NotificationNames.LOGOUT
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case NotificationNames.SETSPACE:
					if (notification.getBody() == Places.STUDENTASSIGNMENTS)
						populate();
					break;
				
				// Happens when we save an Event, and indicates that we should just refresh the view
				case NotificationNames.UPDATEASSIGNMENTSFORUSER:
					assignments.populate(primaryProxy.dataSet.toArray());
					break;
				
				case NotificationNames.LOGOUT:
					assignments.clear();
					break;
			}
		}
		
		override protected function populate():void
		{
			primaryProxy.getAll();
		}
	}
}