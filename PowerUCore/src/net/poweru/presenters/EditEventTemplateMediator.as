package net.poweru.presenters
{
	import flash.events.Event;
	
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.events.ViewEvent;
	import net.poweru.proxies.EventTemplateProxy;
	import net.poweru.utils.InputCollector;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class EditEventTemplateMediator extends BaseEditDialogMediator implements IMediator
	{
		public static const NAME:String = 'EditEventTemplateMediator';
		
		protected var inputCollector:InputCollector;
		
		public function EditEventTemplateMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, EventTemplateProxy, Places.EDITEVENTTEMPLATE);
		}
		
		override protected function onReceivedOne(notification:INotification):void
		{
			inputCollector.addInput('event_template', notification.getBody());
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
			inputCollector = new InputCollector(['event_template']);
			inputCollector.addEventListener(Event.COMPLETE, onInputsCollected);
			
			primaryProxy.findByPK(initialDataProxy.getInitialData(placeName) as Number);
		}
		
		protected function onInputsCollected(event:Event):void
		{
			var inputCollector:InputCollector = event.target as InputCollector;
			editDialog.populate(inputCollector.object['event_template']);
		}
	}
}