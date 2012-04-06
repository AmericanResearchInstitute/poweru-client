package net.poweru.presenters
{
	import flash.events.Event;
	
	import mx.events.FlexEvent;
	
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.events.ViewEvent;
	import net.poweru.proxies.CurriculumProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;

	public class CurriculumsMediator extends BaseMediator implements IMediator
	{
		public static const NAME:String = 'CurriculumsMediator';
		
		public function CurriculumsMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, CurriculumProxy);
		}
		
		protected function get curriculumProxy():CurriculumProxy
		{
			return primaryProxy as CurriculumProxy;
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
			return super.listNotificationInterests().concat(
				NotificationNames.SETSPACE,
				NotificationNames.UPDATECURRICULUMS,
				NotificationNames.UPDATEADMINCURRICULUMSVIEW
			);
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case NotificationNames.SETSPACE:
					if (notification.getBody() == Places.CURRICULUMS)
						populate();
					break;
					
				// Happens when we save a curriculum, and indicates that we should just refresh the view
				case NotificationNames.UPDATECURRICULUMS:
					populate();
					break;
				
				case NotificationNames.UPDATEADMINCURRICULUMSVIEW:
					arrayPopulatedComponent.populate(notification.getBody() as Array);
					break;
				
				default:
					super.handleNotification(notification);
			}
		}
		
		override protected function populate():void
		{	
			curriculumProxy.adminCurriculumsView();
		}
		
	}
}