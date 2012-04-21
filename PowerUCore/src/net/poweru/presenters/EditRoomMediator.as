package net.poweru.presenters
{
	import flash.events.Event;
	
	import net.poweru.Places;
	import net.poweru.proxies.RoomProxy;
	import net.poweru.utils.InputCollector;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class EditRoomMediator extends BaseEditDialogMediator implements IMediator
	{
		public static const NAME:String = 'EditRoomMediator';
		
		protected var inputCollector:InputCollector;
		
		public function EditRoomMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, RoomProxy, Places.EDITROOM);
		}
		
		override protected function onReceivedOne(notification:INotification):void
		{
			inputCollector.addInput('room', notification.getBody());
		}
		
		override protected function populate():void
		{
			if (inputCollector)
				inputCollector.removeEventListener(Event.COMPLETE, onInputsCollected);
			inputCollector = new InputCollector(['room']);
			inputCollector.addEventListener(Event.COMPLETE, onInputsCollected);
			
			primaryProxy.findByPK(initialDataProxy.getInitialData(placeName) as Number);
		}
		
		protected function onInputsCollected(event:Event):void
		{
			var inputCollector:InputCollector = event.target as InputCollector;
			editDialog.populate(inputCollector.object['room']);
		}
	}
}