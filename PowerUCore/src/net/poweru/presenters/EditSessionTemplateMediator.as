package net.poweru.presenters
{
	import flash.events.Event;
	
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.events.ViewEvent;
	import net.poweru.proxies.SessionTemplateProxy;
	import net.poweru.utils.InputCollector;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class EditSessionTemplateMediator extends BaseEditDialogMediator implements IMediator
	{
		public static const NAME:String = 'EditSessionTemplateMediator';
		
		protected var inputCollector:InputCollector;
		
		public function EditSessionTemplateMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, SessionTemplateProxy, Places.EDITSESSIONTEMPLATE);
		}
		
		override protected function onReceivedOne(notification:INotification):void
		{
			inputCollector.addInput('session_template', notification.getBody());
		}
		
		override protected function populate():void
		{
			if (inputCollector)
				inputCollector.removeEventListener(Event.COMPLETE, onInputsCollected);
			inputCollector = new InputCollector(['session_template']);
			inputCollector.addEventListener(Event.COMPLETE, onInputsCollected);
			
			primaryProxy.findByPK(initialDataProxy.getInitialData(placeName) as Number);
		}
		
		protected function onInputsCollected(event:Event):void
		{
			var inputCollector:InputCollector = event.target as InputCollector;
			editDialog.populate(inputCollector.object['session_template']);
		}
	}
}