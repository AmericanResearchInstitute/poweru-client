package net.poweru.presenters
{
	import mx.events.FlexEvent;
	
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.components.interfaces.ICurriculumEnrollments;
	import net.poweru.events.ViewEvent;
	import net.poweru.model.DataSet;
	import net.poweru.proxies.CurriculumEnrollmentUserDetailProxy;
	import net.poweru.proxies.TasksForCurriculumProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class CurriculumEnrollmentMediator extends BaseMediator implements IMediator
	{
		public static const NAME:String = 'CurriculumEnrollmentMediator';
		
		protected var taskProxy:TasksForCurriculumProxy;
		
		public function CurriculumEnrollmentMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, CurriculumEnrollmentUserDetailProxy);
			init();
		}
		
		private function init():void
		{
			taskProxy = getProxy(TasksForCurriculumProxy) as TasksForCurriculumProxy;
		}
		
		protected function get curriculumEnrollments():ICurriculumEnrollments
		{
			return viewComponent as ICurriculumEnrollments;
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
				NotificationNames.UPDATECURRICULUMENROLLMENTS,
				NotificationNames.UPDATECURRICULUMENROLLMENTSUSERDETAIL,
				NotificationNames.UPDATETASKSFORCURRICULUM
			);
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case NotificationNames.SETSPACE:
					if (notification.getBody() == Places.CURRICULUMENROLLMENTS)
					{
						populate();
						clearableComponent.clear();
					}
					break;
				
				case NotificationNames.UPDATECURRICULUMENROLLMENTS:
					populate();
					break;
				
				case NotificationNames.UPDATECURRICULUMENROLLMENTSUSERDETAIL:
					curriculumEnrollments.populate(primaryProxy.dataSet.toArray());
					break;
				
				case NotificationNames.UPDATETASKSFORCURRICULUM:
					curriculumEnrollments.setTasks((notification.getBody() as DataSet).toArray());
					break;
				
				default:
					super.handleNotification(notification);
			}
		}
		
		override protected function populate():void
		{	
			primaryProxy.getAll();
		}
		
		//	event.body should be PK of a curriculum
		protected function onFetch(event:ViewEvent):void
		{
			taskProxy.getFiltered({'exact': {'curriculums':event.body}});
		}
		
		override protected function onRefresh(event:ViewEvent):void
		{
			super.onRefresh(event);
			taskProxy.clear();
		}
	}
}