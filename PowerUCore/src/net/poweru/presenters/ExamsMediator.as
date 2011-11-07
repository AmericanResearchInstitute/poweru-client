package net.poweru.presenters
{
	import flash.events.Event;
	
	import mx.events.FlexEvent;
	
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.components.interfaces.IExams;
	import net.poweru.events.ViewEvent;
	import net.poweru.model.DataSet;
	import net.poweru.proxies.ExamProxy;
	import net.poweru.utils.InputCollector;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class ExamsMediator extends BaseMediator implements IMediator
	{
		public static const NAME:String = 'ExamsMediator';
		
		protected var inputCollector:InputCollector;
		protected var populatedSinceLastClear:Boolean;
		
		public function ExamsMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, ExamProxy);
		}
		
		protected function get exams():IExams
		{
			return viewComponent as IExams;
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
				NotificationNames.UPDATEEXAMS,
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case NotificationNames.LOGOUT:
					exams.clear();
					populatedSinceLastClear = false;
					break;
				
				case NotificationNames.SETSPACE:
					if (notification.getBody() == Places.EXAMS && !populatedSinceLastClear)
						populate();
					break;
				
				// Happens when we save an exam, and indicates that we should just refresh the view
				case NotificationNames.UPDATEEXAMS:
					inputCollector.addInput('exams', (primaryProxy.dataSet).toArray());
					break;
				
				default:
					super.handleNotification(notification);
			}
		}
		
		protected function onInputsCollected(event:Event):void
		{
			populatedSinceLastClear = true;
			
			var inputCollector:InputCollector = event.target as InputCollector;
			exams.populate(inputCollector.object['exams']);
		}
		
		override protected function populate():void
		{
			if (inputCollector)
				inputCollector.removeEventListener(Event.COMPLETE, onInputsCollected);
			inputCollector = new InputCollector(['exams']);
			inputCollector.addEventListener(Event.COMPLETE, onInputsCollected);
			
			primaryProxy.getAll();
		}
	}
}