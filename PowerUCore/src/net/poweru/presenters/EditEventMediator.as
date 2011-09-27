package net.poweru.presenters
{
	import flash.events.Event;
	
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.events.ViewEvent;
	import net.poweru.proxies.EventProxy;
	import net.poweru.utils.InputCollector;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class EditEventMediator extends BaseEditDialogMediator implements IMediator
	{
		public static const NAME:String = 'EditEventMediator';
		
		protected var inputCollector:InputCollector;
		
		public function EditEventMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, EventProxy, Places.EDITEVENT);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				NotificationNames.LOGOUT,
				NotificationNames.DIALOGPRESENTED,
				NotificationNames.RECEIVEDONE,
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case NotificationNames.LOGOUT:
					if (editDialog)
						editDialog.clear();
					break;
				
				case NotificationNames.DIALOGPRESENTED:
					var body:String = notification.getBody() as String;
					if (body != null && body == placeName)
						populate();
					break;
				
				case NotificationNames.RECEIVEDONE:
					if (notification.getType() == primaryProxy.getProxyName())
						inputCollector.addInput('event', notification.getBody());
					break;
			}
		}
		
		override protected function onSubmit(event:ViewEvent):void
		{
			var newObject:Object = event.body;
			primaryProxy.save(newObject);
			sendNotification(NotificationNames.REMOVEDIALOG, displayObject);
		}
		
		override protected function populate():void
		{
			if (inputCollector)
				inputCollector.removeEventListener(Event.COMPLETE, onInputsCollected);
			inputCollector = new InputCollector(['event']);
			inputCollector.addEventListener(Event.COMPLETE, onInputsCollected);
			
			primaryProxy.findByPK(initialDataProxy.getInitialData(placeName) as Number);
		}
		
		protected function onInputsCollected(event:Event):void
		{
			var inputCollector:InputCollector = event.target as InputCollector;
			editDialog.populate(inputCollector.object['event']);
		}
	}
}