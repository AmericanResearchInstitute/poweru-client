package net.poweru.presenters
{
	import mx.events.FlexEvent;
	
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.components.interfaces.IEventTemplates;
	import net.poweru.events.ViewEvent;
	import net.poweru.model.DataSet;
	import net.poweru.proxies.EventTemplateProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class EventTemplatesMediator extends BaseMediator implements IMediator
	{
		public static const NAME:String = 'EventTemplatesMediator';
		
		public function EventTemplatesMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, EventTemplateProxy);
		}
		
		protected function get eventTemplates():IEventTemplates
		{
			return displayObject as IEventTemplates;
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
				NotificationNames.UPDATEEVENTTEMPLATES,
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case NotificationNames.SETSPACE:
					if (notification.getBody() == Places.EVENTTEMPLATES)
						populate();
					break;
				
				// Happens when we save an EventTemplate, and indicates that we should just refresh the view
				case NotificationNames.UPDATEEVENTTEMPLATES:
					eventTemplates.populate((notification.getBody() as DataSet).toArray());
					break;
			}
		}
		
		override protected function populate():void
		{
			primaryProxy.getAll(['title', 'name_prefix', 'lead_time', 'description']);
		}
	}
}