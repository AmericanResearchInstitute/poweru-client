package net.poweru.presenters
{
	import flash.events.Event;
	
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.proxies.VenueProxy;
	import net.poweru.utils.InputCollector;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class EditVenueMediator extends BaseEditDialogMediator implements IMediator
	{
		public static const NAME:String = 'EditVenueMediator';
		
		protected var inputCollector:InputCollector;
		
		public function EditVenueMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, VenueProxy, Places.EDITVENUE);
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
				case NotificationNames.RECEIVEDONE:
					if (notification.getType() == primaryProxy.getProxyName())
						inputCollector.addInput('venue', notification.getBody());
					break;
				
				default:
					super.handleNotification(notification);
			}
		}
		
		override protected function populate():void
		{
			if (inputCollector)
				inputCollector.removeEventListener(Event.COMPLETE, onInputsCollected);
			inputCollector = new InputCollector(['venue']);
			inputCollector.addEventListener(Event.COMPLETE, onInputsCollected);
			
			primaryProxy.findByPK(initialDataProxy.getInitialData(placeName) as Number);
		}
		
		protected function onInputsCollected(event:Event):void
		{
			var inputCollector:InputCollector = event.target as InputCollector;
			editDialog.populate(inputCollector.object['venue']);
		}
	}
}