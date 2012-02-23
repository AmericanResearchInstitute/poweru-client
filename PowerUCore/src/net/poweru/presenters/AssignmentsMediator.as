package net.poweru.presenters
{
	import flash.events.Event;
	
	import mx.events.FlexEvent;
	
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.components.interfaces.IPopulatedComponent;
	import net.poweru.events.ViewEvent;
	import net.poweru.proxies.AssignmentProxy;
	import net.poweru.utils.InputCollector;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class AssignmentsMediator extends BaseMediator implements IMediator
	{
		public static const NAME:String = 'AssignmentsMediator';
		
		protected var inputCollector:InputCollector;
		protected var populatedSinceLastClear:Boolean;
		
		public function AssignmentsMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, AssignmentProxy);
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
				NotificationNames.UPDATEASSIGNMENTS,
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case NotificationNames.LOGOUT:
					populatedComponent.clear();
					populatedSinceLastClear = false;
					break;
				
				case NotificationNames.SETSPACE:
					if (notification.getBody() == Places.ASSIGNMENTS && !populatedSinceLastClear)
						populate();
					break;
				
				case NotificationNames.UPDATEASSIGNMENTS:
					inputCollector.addInput('data', (primaryProxy.dataSet).toArray());
					break;
				
				default:
					super.handleNotification(notification);
			}
		}
		
		protected function onInputsCollected(event:Event):void
		{
			populatedSinceLastClear = true;
			
			var inputCollector:InputCollector = event.target as InputCollector;
			populatedComponent.populate(inputCollector.object['data']);
		}
		
		override protected function populate():void
		{
			if (inputCollector)
				inputCollector.removeEventListener(Event.COMPLETE, onInputsCollected);
			inputCollector = new InputCollector(['data']);
			inputCollector.addEventListener(Event.COMPLETE, onInputsCollected);
			
			primaryProxy.getFiltered({'member' : {'status' : ['unpaid', 'pending', 'assigned']}});
		}
	}
}