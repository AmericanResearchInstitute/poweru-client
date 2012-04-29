package net.poweru.presenters
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.components.interfaces.IBulkEnrollInEvent;
	import net.poweru.events.ViewEvent;
	import net.poweru.model.DataSet;
	import net.poweru.placemanager.InitialDataProxy;
	import net.poweru.proxies.AssignmentProxy;
	import net.poweru.proxies.SessionProxy;
	import net.poweru.utils.InputCollector;
	import net.poweru.utils.PKArrayCollection;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class BulkEnrollInEventMediator extends BaseMediator implements IMediator
	{
		public static const NAME:String = 'BulkEnrollInEventMediator';
		
		protected var inputCollector:InputCollector;
		protected var initialDataProxy:InitialDataProxy;
		protected var sessionProxy:SessionProxy;
		
		public function BulkEnrollInEventMediator(viewComponent:DisplayObject)
		{
			super(NAME, viewComponent, AssignmentProxy);
			init();
		}
		
		private function init():void
		{
			initialDataProxy = getProxy(InitialDataProxy) as InitialDataProxy;
			sessionProxy = getProxy(SessionProxy) as SessionProxy;
		}
		
		protected function get assignmentProxy():AssignmentProxy
		{
			return primaryProxy as AssignmentProxy;
		}
		
		override protected function addEventListeners():void
		{
			displayObject.addEventListener(ViewEvent.CANCEL, onCancel);
			displayObject.addEventListener(ViewEvent.SUBMIT, onSubmit);
		}
		
		override protected function removeEventListeners():void
		{
			displayObject.removeEventListener(ViewEvent.CANCEL, onCancel);
			displayObject.removeEventListener(ViewEvent.SUBMIT, onSubmit);
		}
		
		protected function onCancel(event:ViewEvent):void
		{
			dialog.clear();
			sendNotification(NotificationNames.REMOVEDIALOG, displayObject);
		}
		
		protected function get dialog():IBulkEnrollInEvent
		{
			return viewComponent as IBulkEnrollInEvent;
		}
		
		override public function listNotificationInterests():Array
		{
			return super.listNotificationInterests().concat(
				NotificationNames.DIALOGPRESENTED,
				NotificationNames.UPDATESESSIONS
			);
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case NotificationNames.DIALOGPRESENTED:
					var body:String = notification.getBody() as String;
					if (body != null && body == Places.BULKENROLLINEVENT)
						populate();
					break;
				
				case NotificationNames.UPDATESESSIONS:
					var sessions:DataSet = notification.getBody() as DataSet;
					var correctEvent:Boolean = true;
					for each (var session:Object in sessions)
					{
						if (session['event'] != inputCollector.object['event']['id'])
						{
							correctEvent = false;
							break;
						}
					}
					if (correctEvent)
						inputCollector.addInput('sessions', sessions.toArray());
					break;
				
				default:
					super.handleNotification(notification);
			}
		}
		
		protected function onSubmit(event:ViewEvent):void
		{
			var users:PKArrayCollection = new PKArrayCollection(event.body['users'] as Array);
			var surr:Number = event.body['session_user_role_requirement'];
			assignmentProxy.bulkCreate(surr, users.toArray());
			sendNotification(NotificationNames.REMOVEDIALOG, displayObject);
			dialog.clear();
		}
		
		override protected function populate():void
		{
			if (inputCollector)
				inputCollector.removeEventListener(Event.COMPLETE, onInputsCollected);
			inputCollector = new InputCollector(['sessions']);
			inputCollector.addEventListener(Event.COMPLETE, onInputsCollected);
			
			var initialData:Object = initialDataProxy.getInitialData(Places.BULKENROLLINEVENT);
			inputCollector.object['event'] = initialData['event'];
			inputCollector.object['users'] = initialData['users'];
			sessionProxy.findByIDs(initialData['event']['sessions']);
		}
		
		protected function onInputsCollected(event:Event):void
		{
			var inputCollector:InputCollector = event.target as InputCollector;
			dialog.populate(inputCollector.object['event'], inputCollector.object['sessions'], inputCollector.object['users']);
		}
	}
}