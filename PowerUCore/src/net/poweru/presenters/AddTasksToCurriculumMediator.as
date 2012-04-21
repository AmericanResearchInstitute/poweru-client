package net.poweru.presenters
{
	import flash.events.Event;
	
	import net.poweru.ApplicationFacade;
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.model.DataSet;
	import net.poweru.proxies.CurriculumProxy;
	import net.poweru.proxies.TaskProxy;
	import net.poweru.utils.InputCollector;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class AddTasksToCurriculumMediator extends BaseEditDialogMediator implements IMediator
	{
		public static const NAME:String = 'AddTasksToCurriculumMediator';
		
		protected var inputCollector:InputCollector;
		protected var taskProxy:TaskProxy;
		
		public function AddTasksToCurriculumMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, CurriculumProxy, Places.ADDTASKSTOCURRICULUM);
			init();
		}
		
		private function init():void
		{
			taskProxy = getProxy(TaskProxy) as TaskProxy;
		}
		
		protected function get curriculumProxy():CurriculumProxy
		{
			return primaryProxy as CurriculumProxy;
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				NotificationNames.LOGOUT,
				NotificationNames.DIALOGPRESENTED,
				NotificationNames.RECEIVEDONE,
				NotificationNames.UPDATETASKS,
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case NotificationNames.RECEIVEDONE:
					if (notification.getType() == primaryProxy.getProxyName())
						inputCollector.addInput('curriculum', notification.getBody());
					break;
				
				case NotificationNames.UPDATETASKS:
					var body2:DataSet = notification.getBody() as DataSet;
					inputCollector.addInput('tasks', body2.toArray());
					break;
				
				default:
					super.handleNotification(notification);
			}
		}
		
		override protected function populate():void
		{
			if (inputCollector)
				inputCollector.removeEventListener(Event.COMPLETE, onInputsCollected);
			
			inputCollector = new InputCollector(['curriculum', 'tasks']);
			inputCollector.addEventListener(Event.COMPLETE, onInputsCollected);
			primaryProxy.findByPK(initialDataProxy.getInitialData(placeName) as Number);
			taskProxy.getAll();
		}
		
		protected function onInputsCollected(event:Event):void
		{
			var collector:InputCollector = event.target as InputCollector;
			editDialog.populate(collector.object['curriculum'], collector.object['tasks'] as Array);
		}
	}
}