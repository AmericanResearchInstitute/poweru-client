package net.poweru.presenters
{
	import flash.events.Event;
	
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.model.DataSet;
	import net.poweru.proxies.ExamProxy;
	import net.poweru.utils.InputCollector;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class ChooseExamMediator extends BaseChooserMediator implements IMediator
	{
		public static const NAME:String = 'ChooseExamMediator';
		
		public var inputCollector:InputCollector;
		
		public function ChooseExamMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, Places.CHOOSEEXAM, NotificationNames.UPDATEEXAMS, ExamProxy);
		}
		
		override public function listNotificationInterests():Array
		{
			var ret:Array = super.listNotificationInterests();
			ret = ret.concat(
				NotificationNames.LOGOUT,
				NotificationNames.UPDATEEXAMS
			);
			return ret;
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case updateNotification:
					inputCollector.addInput('exams', (notification.getBody() as DataSet).toArray());
					break;

				default:
					super.handleNotification(notification);
			}
		}
		
		override protected function populate():void
		{
			if (inputCollector != null)
				inputCollector.removeEventListener(Event.COMPLETE, onInputsCollected);
			
			inputCollector = new InputCollector(['exams']);
			inputCollector.addEventListener(Event.COMPLETE, onInputsCollected);
			primaryProxy.getAll();
		}
		
		protected function onInputsCollected(event:Event):void
		{
			chooser.populate(inputCollector.object['exams']);
		}
	}
}