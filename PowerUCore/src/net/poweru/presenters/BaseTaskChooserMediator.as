package net.poweru.presenters
{
	import flash.events.Event;
	
	import net.poweru.model.DataSet;
	import net.poweru.utils.InputCollector;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	/*	Base mediator that can retrieve all records from its proxy and populate
		them to an IChooser */
	public class BaseTaskChooserMediator extends BaseChooserMediator implements IMediator
	{
		protected var inputCollector:InputCollector;
		
		public function BaseTaskChooserMediator(mediatorName:String, viewComponent:Object, placeName:String, updateNotification:String, primaryProxyClass:Class=null)
		{
			super(mediatorName, viewComponent, placeName, updateNotification, primaryProxyClass);
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case updateNotification:
					inputCollector.addInput('tasks', (notification.getBody() as DataSet).toArray());
					break;
				
				default:
					super.handleNotification(notification);
			}
		}
		
		override protected function populate():void
		{
			if (inputCollector != null)
				inputCollector.removeEventListener(Event.COMPLETE, onInputsCollected);
			
			inputCollector = new InputCollector(['tasks']);
			inputCollector.addEventListener(Event.COMPLETE, onInputsCollected);
			primaryProxy.getAll();
		}
		
		protected function onInputsCollected(event:Event):void
		{
			chooser.populate(inputCollector.object['tasks']);
		}
	}
}