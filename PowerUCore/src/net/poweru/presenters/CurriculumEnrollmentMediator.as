package net.poweru.presenters
{
	import mx.events.FlexEvent;
	
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.components.interfaces.ICurriculumEnrollments;
	import net.poweru.events.ViewEvent;
	import net.poweru.proxies.CurriculumEnrollmentProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class CurriculumEnrollmentMediator extends BaseMediator implements IMediator
	{
		public static const NAME:String = 'CurriculumEnrollmentMediator';
		
		public function CurriculumEnrollmentMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, CurriculumEnrollmentProxy);
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
				NotificationNames.UPDATECURRICULUMENROLLMENTS,
				NotificationNames.UPDATECURRICULUMENROLLMENTSVIEW,
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case NotificationNames.SETSPACE:
					if (notification.getBody() == Places.CURRICULUMENROLLMENTS)
						populate();
					break;
				
				case NotificationNames.UPDATECURRICULUMENROLLMENTS:
					curriculumEnrollmentProxy.curriculumEnrollmentsView();
					break;
				
				case NotificationNames.UPDATECURRICULUMENROLLMENTSVIEW:
					curriculumEnrollments.populate(notification.getBody() as Array);
					break;
			}
		}
		
		override protected function populate():void
		{	
			curriculumEnrollmentProxy.curriculumEnrollmentsView();
		}
	}
}