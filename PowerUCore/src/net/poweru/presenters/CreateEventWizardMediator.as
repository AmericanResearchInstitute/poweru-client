package net.poweru.presenters
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import mx.core.Container;
	import mx.events.ChildExistenceChangedEvent;
	
	import net.poweru.NotificationNames;
	import net.poweru.components.dialogs.BaseDialog;
	import net.poweru.components.interfaces.ICreateEventWizard;
	import net.poweru.events.ViewEvent;
	import net.poweru.model.DataSet;
	import net.poweru.placemanager.InitialDataProxy;
	import net.poweru.proxies.EventProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class CreateEventWizardMediator extends BaseMediator implements IMediator
	{
		public static const NAME:String = 'CreateEventWizardMediator';
		
		protected var initialDataProxy:InitialDataProxy;
		protected var nextPlaceName:String;
		
		public function CreateEventWizardMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, EventProxy);
			init();
		}
		
		private function init():void
		{
			initialDataProxy = getProxy(InitialDataProxy) as InitialDataProxy;
		}
		
		override public function listNotificationInterests():Array
		{
			return super.listNotificationInterests().concat(
				NotificationNames.UPDATEEVENTS,
				NotificationNames.UPDATESESSIONS
			);
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case NotificationNames.UPDATEEVENTS:
					var events:DataSet = notification.getBody() as DataSet;
					if (events.length == 1)
						wizard.setEventID(events[0].id);
					break;
				
				case NotificationNames.UPDATESESSIONS:
					var sessions:DataSet = notification.getBody() as DataSet;
					if (sessions.length == 1)
						wizard.setSessionID(sessions[0].id);
					break;
				
				default:
					super.handleNotification(notification);
			}
		}
		
		protected function get wizard():ICreateEventWizard
		{
			return viewComponent as ICreateEventWizard;
		}
		
		override protected function addEventListeners():void
		{
			displayObject.addEventListener(ViewEvent.SETOTHERSPACE, onSetOtherSpace);
			displayObject.addEventListener(ViewEvent.CANCEL, onCancel);
			displayObject.addEventListener(ViewEvent.FETCH, onFetch);
		}
		
		override protected function removeEventListeners():void
		{
			displayObject.removeEventListener(ViewEvent.SETOTHERSPACE, onSetOtherSpace);
			displayObject.removeEventListener(ViewEvent.CANCEL, onCancel);
			displayObject.removeEventListener(ViewEvent.FETCH, onFetch);
		}
		
		protected function onSetOtherSpace(event:ViewEvent):void
		{
			sendNotification(NotificationNames.SETOTHERSPACE, event.body, event.subType);
		}
		
		protected function onFetch(event:ViewEvent):void
		{
			var body:Array = event.body as Array;
			initialDataProxy.setInitialData(event.subType, body[1]);
			(body[0] as Container).addEventListener(ChildExistenceChangedEvent.CHILD_ADD, onDialogPutIntoContainer);
			nextPlaceName = event.subType;
			sendNotification(NotificationNames.SETOTHERSPACE, body[0], event.subType);
		}
		
		protected function onDialogPutIntoContainer(event:Event):void
		{
			(event.target as IEventDispatcher).removeEventListener(ChildExistenceChangedEvent.CHILD_ADD, onDialogPutIntoContainer);
			if (nextPlaceName.length > 0)
			{
				var dialog:BaseDialog = (event.target as Container).getChildAt(0) as BaseDialog;
				if (dialog != null)
				{
					sendNotification(NotificationNames.DIALOGPRESENTED, nextPlaceName);
					nextPlaceName = '';
				}
			}
		}
		
		protected function onCancel(event:ViewEvent):void
		{
			sendNotification(NotificationNames.REMOVEDIALOG, displayObject);
			if (event.body != null)
			{
				// refresh the event so any session IDs show up on it
				var eventID:Number = event.body as Number;
				primaryProxy.getFiltered({'exact': {'id': eventID}});
			}
		}
	}
}