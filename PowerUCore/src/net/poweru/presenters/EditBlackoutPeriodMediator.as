package net.poweru.presenters
{
	import flash.events.Event;
	
	import net.poweru.Places;
	import net.poweru.proxies.BlackoutPeriodProxy;
	import net.poweru.utils.InputCollector;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class EditBlackoutPeriodMediator extends BaseEditDialogMediator implements IMediator
	{
		public static const NAME:String = 'EditBlackoutPeriodMediator';
		
		protected var inputCollector:InputCollector;
		
		public function EditBlackoutPeriodMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, BlackoutPeriodProxy, Places.EDITBLACKOUTPERIOD);
		}
		
		override protected function onReceivedOne(notification:INotification):void
		{
			inputCollector.addInput('data', notification.getBody());
		}
		
		override protected function populate():void
		{
			if (inputCollector)
				inputCollector.removeEventListener(Event.COMPLETE, onInputsCollected);
			inputCollector = new InputCollector(['data']);
			inputCollector.addEventListener(Event.COMPLETE, onInputsCollected);
			
			primaryProxy.findByPK(initialDataProxy.getInitialData(placeName) as Number);
		}
		
		protected function onInputsCollected(event:Event):void
		{
			var inputCollector:InputCollector = event.target as InputCollector;
			editDialog.populate(inputCollector.object['data']);
		}
	}
}