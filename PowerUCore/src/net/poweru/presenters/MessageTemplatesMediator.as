package net.poweru.presenters
{
	import flash.events.Event;
	
	import mx.events.FlexEvent;
	
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.events.ViewEvent;
	import net.poweru.proxies.MessageTemplateProxy;
	import net.poweru.utils.InputCollector;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class MessageTemplatesMediator extends BaseMediator implements IMediator
	{
		public static const NAME:String = 'MessageTemplatesMediator';
		
		protected var inputCollector:InputCollector;
		protected var populatedSinceLastClear:Boolean;
		
		public function MessageTemplatesMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, MessageTemplateProxy);
		}
		
		override protected function addEventListeners():void
		{
			displayObject.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			displayObject.addEventListener(ViewEvent.SHOWDIALOG, onShowDialog);
			displayObject.addEventListener(ViewEvent.REFRESH, onRefresh);
		}
		
		override protected function removeEventListeners():void
		{
			displayObject.removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			displayObject.removeEventListener(ViewEvent.SHOWDIALOG, onShowDialog);
			displayObject.removeEventListener(ViewEvent.REFRESH, onRefresh);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				NotificationNames.LOGOUT,
				NotificationNames.SETSPACE,
				NotificationNames.UPDATEMESSAGETEMPLATES,
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case NotificationNames.LOGOUT:
					populatedComponent.clear();
					populatedSinceLastClear = false;
					break;
				
				case NotificationNames.SETSPACE:
					if (notification.getBody() == Places.MESSAGETEMPLATES && !populatedSinceLastClear)
						populate();
					break;
				
				// Happens when we save a message template, and indicates that we should just refresh the view
				case NotificationNames.UPDATEMESSAGETEMPLATES:
					inputCollector.addInput('data', (primaryProxy.dataSet).toArray());
					break;
				
				default:
					super.handleNotification(notification);
			}
		}
		
		protected function onInputsCollected(event:Event):void
		{
			populatedSinceLastClear = true;
			
			var inputCollector:InputCollector = event.target as InputCollector;
			populatedComponent.populate(inputCollector.object['data']);
		}
		
		override protected function populate():void
		{
			if (inputCollector)
				inputCollector.removeEventListener(Event.COMPLETE, onInputsCollected);
			inputCollector = new InputCollector(['data']);
			inputCollector.addEventListener(Event.COMPLETE, onInputsCollected);
			
			primaryProxy.getAll();
		}
	}
}