package net.poweru.presenters.student
{
	import mx.events.FlexEvent;
	
	import net.poweru.ApplicationFacade;
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.components.student.interfaces.ICurriculumEnrollments;
	import net.poweru.events.ViewEvent;
	import net.poweru.model.DataSet;
	import net.poweru.presenters.BaseMediator;
	import net.poweru.proxies.AssignmentsForUserProxy;
	import net.poweru.proxies.CurriculumEnrollmentProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class CurriculumEnrollmentMediator extends BaseMediator implements IMediator
	{
		public static const NAME:String = 'StudentCurriculumEnrollmentMediator';
		
		protected var assignmentsForUserProxy:AssignmentsForUserProxy;
		
		public function CurriculumEnrollmentMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, CurriculumEnrollmentProxy);
			assignmentsForUserProxy = (facade as ApplicationFacade).retrieveOrRegisterProxy(AssignmentsForUserProxy) as AssignmentsForUserProxy;
		}
		
		protected function get curriculumEnrollments():ICurriculumEnrollments
		{
			return viewComponent as ICurriculumEnrollments;
		}
		
		protected function get curriculumEnrollmentProxy():CurriculumEnrollmentProxy
		{
			return primaryProxy as CurriculumEnrollmentProxy;
		}
		
		override protected function addEventListeners():void
		{
			displayObject.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			displayObject.addEventListener(ViewEvent.REFRESH, onRefresh);
			displayObject.addEventListener(ViewEvent.FETCH, onFetch);
			displayObject.addEventListener(ViewEvent.SHOWDIALOG, onShowDialog);
		}
		
		override protected function removeEventListeners():void
		{
			displayObject.removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);	
			displayObject.removeEventListener(ViewEvent.REFRESH, onRefresh);
			displayObject.removeEventListener(ViewEvent.FETCH, onFetch);
			displayObject.removeEventListener(ViewEvent.SHOWDIALOG, onShowDialog);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				NotificationNames.LOGOUT,
				NotificationNames.SETSPACE,
				NotificationNames.UPDATEASSIGNMENTSFORUSER,
				NotificationNames.UPDATECURRICULUMENROLLMENTS,
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case NotificationNames.LOGOUT:
					curriculumEnrollments.clear();
					break;
					
				case NotificationNames.SETSPACE:
					if (notification.getBody() == Places.STUDENTCURRICULUMENROLLMENTS)
						populate();
					break;
				
				case NotificationNames.UPDATEASSIGNMENTSFORUSER:
					curriculumEnrollments.setAssignments((notification.getBody() as DataSet).toArray());
					break;
				
				case NotificationNames.UPDATECURRICULUMENROLLMENTS:
					curriculumEnrollments.populate((notification.getBody() as DataSet).toArray());
					break;
			}
		}
		
		override protected function populate():void
		{	
			curriculumEnrollmentProxy.getStudentCurriculumEnrollments();
		}
		
		// User clicked on a CurriculumEnrollment, so we should fetch related Assignments.
		protected function onFetch(event:ViewEvent):void
		{
			assignmentsForUserProxy.getByUserAndCurriculumEnrollment(event.body as Number);
		}
	}
}