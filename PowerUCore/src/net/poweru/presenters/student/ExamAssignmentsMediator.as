package net.poweru.presenters.student
{
	import mx.events.FlexEvent;
	
	import net.poweru.Constants;
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.components.student.interfaces.IExamAssignments;
	import net.poweru.events.ViewEvent;
	import net.poweru.model.DataSet;
	import net.poweru.presenters.BaseMediator;
	import net.poweru.proxies.ExamAssignmentsForUserProxy;
	import net.poweru.proxies.ExamSessionsForExamProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class ExamAssignmentsMediator extends BaseMediator implements IMediator
	{
		public static const NAME:String = 'ExamAssignmentsMediator';
		
		protected var examSessionsForExamProxy:ExamSessionsForExamProxy;
		
		public function ExamAssignmentsMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, ExamAssignmentsForUserProxy);
			init();
		}
		
		private function init():void
		{
			examSessionsForExamProxy = getProxy(ExamSessionsForExamProxy) as ExamSessionsForExamProxy;
		}
		
		protected function get examAssignments():IExamAssignments
		{
			return viewComponent as IExamAssignments
		}
		
		override protected function addEventListeners():void
		{
			displayObject.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			displayObject.addEventListener(ViewEvent.REFRESH, onRefresh);
			displayObject.addEventListener(ViewEvent.SHOWDIALOG, onShowDialog);
			displayObject.addEventListener(ViewEvent.FETCH, onFetch);
		}
		
		override protected function removeEventListeners():void
		{
			displayObject.removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);	
			displayObject.removeEventListener(ViewEvent.REFRESH, onRefresh);
			displayObject.removeEventListener(ViewEvent.SHOWDIALOG, onShowDialog);
			displayObject.removeEventListener(ViewEvent.FETCH, onFetch);
		}
		
		override public function listNotificationInterests():Array
		{
			return super.listNotificationInterests().concat(
				NotificationNames.SETSPACE,
				NotificationNames.UPDATEEXAMASSIGNMENTSFORUSER,
				NotificationNames.UPDATEEXAMSESSIONSFOREXAM
			);
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case NotificationNames.SETSPACE:
					if (notification.getBody() == Places.EXAMASSIGNMENTS)
						populate();
					break;
				
				// Happens when we save an Exam, and indicates that we should just refresh the view
				case NotificationNames.UPDATEEXAMASSIGNMENTSFORUSER:
					arrayPopulatedComponent.populate(primaryProxy.dataSet.toArray());
					break;
				
				case NotificationNames.UPDATEEXAMSESSIONSFOREXAM:
					examAssignments.setExamSessions((notification.getBody() as DataSet).toArray());
					break;
				
				default:
					super.handleNotification(notification);
			}
		}
		
		override protected function populate():void
		{
			primaryProxy.getFiltered({'member': {'status' : Constants.ASSIGNMENT_INCOMPLETE_STATUSES}});
		}
		
		override protected function onRefresh(event:ViewEvent):void
		{
			super.onRefresh(event);
			examSessionsForExamProxy.clear();
		}
		
		protected function onFetch(event:ViewEvent):void
		{
			examSessionsForExamProxy.getFiltered({'exact': {'assignment' : event.body.id}});
		}
	}
}