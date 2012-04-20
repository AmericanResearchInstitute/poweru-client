package net.poweru.presenters
{
	import flash.events.Event;
	
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.events.ViewEvent;
	import net.poweru.model.DataSet;
	import net.poweru.proxies.AssignmentProxy;
	import net.poweru.utils.InputCollector;
	import net.poweru.utils.PKArrayCollection;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class EditEnrollmentsMediator extends BaseEditDialogMediator implements IMediator
	{
		public static const NAME:String = 'EditEnrollmentsMediator';
		
		protected var inputCollector:InputCollector;
		
		public function EditEnrollmentsMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, AssignmentProxy, Places.EDITENROLLMENTS);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				NotificationNames.LOGOUT,
				NotificationNames.DIALOGPRESENTED,
				NotificationNames.UPDATEASSIGNMENTS
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case NotificationNames.UPDATEASSIGNMENTS:
					var assignments:DataSet = notification.getBody() as DataSet;
					var correctData:Boolean = true;
					var surrIDs:PKArrayCollection = new PKArrayCollection(inputCollector.object['surrs']);
					for each (var assignment:Object in assignments)
					{
						if (!surrIDs.contains(assignment['task']['id']))
						{
							correctData = false;
							break;
						}
					}
					if (correctData)
						inputCollector.addInput('assignments', assignments.toArray());
					break;
				
				default:
					super.handleNotification(notification);
			}
		}
		
		override protected function onSubmit(event:ViewEvent):void
		{
			//var newObject:Object = event.body;
			//primaryProxy.save(newObject);
			sendNotification(NotificationNames.REMOVEDIALOG, displayObject);
		}
		
		override protected function populate():void
		{
			editDialog.clear();
			if (inputCollector)
				inputCollector.removeEventListener(Event.COMPLETE, onInputsCollected);
			inputCollector = new InputCollector(['surrs', 'assignments']);
			inputCollector.addEventListener(Event.COMPLETE, onInputsCollected);
			
			var session:Object = initialDataProxy.getInitialData(placeName);
			inputCollector.addInput('surrs', session['session_user_role_requirements']);
			var surrArray:PKArrayCollection = new PKArrayCollection(session['session_user_role_requirements']);
			
			primaryProxy.getFiltered({'member': {'task' : surrArray.toArray()}});
		}
		
		protected function onInputsCollected(event:Event):void
		{
			editDialog.clear();
			var inputCollector:InputCollector = event.target as InputCollector;
			editDialog.populate(inputCollector.object['surrs'], inputCollector.object['assignments']);
		}
	}
}