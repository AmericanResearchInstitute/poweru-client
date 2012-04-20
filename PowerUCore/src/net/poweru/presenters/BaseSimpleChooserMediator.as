package net.poweru.presenters
{
	import flash.events.Event;
	
	import net.poweru.utils.InputCollector;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	/*	Base mediator that can retrieve all records from its proxy and populate
		them to an IChooser. If you need to populate other data as well, you can
		override the populate() method to add your own requirements and fetch them,
		the listNotificationInterests() method, the handleNotification() method,
		and the onInputsCollected() method. */
	public class BaseSimpleChooserMediator extends BaseChooserMediator implements IMediator
	{
		protected var inputCollector:InputCollector;
		
		public function BaseSimpleChooserMediator(mediatorName:String, viewComponent:Object, placeName:String, updateNotification:String, primaryProxyClass:Class=null)
		{
			super(mediatorName, viewComponent, placeName, updateNotification, primaryProxyClass);
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case updateNotification:
					var data:Array = applyExcludes(primaryProxy.dataSet.toArray());
					inputCollector.addInput('data', data);
					break;
				
				default:
					super.handleNotification(notification);
			}
		}
		
		protected function buildInputCollector():void
		{
			if (inputCollector != null)
				inputCollector.removeEventListener(Event.COMPLETE, onInputsCollected);
			
			inputCollector = new InputCollector(['data']);
			inputCollector.addEventListener(Event.COMPLETE, onInputsCollected);
		}
		
		override protected function populate():void
		{
			super.populate();
			buildInputCollector();
			primaryProxy.getAll();
		}
		
		protected function onInputsCollected(event:Event):void
		{
			chooser.populate(inputCollector.object['data']);
		}
	}
}