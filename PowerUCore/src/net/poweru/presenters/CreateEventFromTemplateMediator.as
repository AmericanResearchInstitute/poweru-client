package net.poweru.presenters
{
	import flash.events.Event;
	
	import net.poweru.ApplicationFacade;
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.components.interfaces.ICreateEventFromTemplateDialog;
	import net.poweru.model.DataSet;
	import net.poweru.placemanager.InitialDataProxy;
	import net.poweru.proxies.EventProxy;
	import net.poweru.proxies.EventTemplateProxy;
	import net.poweru.proxies.SessionTemplateProxy;
	import net.poweru.utils.InputCollector;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class CreateEventFromTemplateMediator extends BaseCreateDialogMediator implements IMediator
	{
		public static const NAME:String = 'CreateEventFromTemplateMediator';
		
		protected var inputCollector:InputCollector;
		
		protected var initialDataProxy:InitialDataProxy;
		protected var eventTemplateProxy:EventTemplateProxy;
		protected var sessionTemplateProxy:SessionTemplateProxy;
		
		protected var waitingForSessionTemplates:Boolean;
		
		public function CreateEventFromTemplateMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, EventProxy);
			
			initialDataProxy = (facade as ApplicationFacade).retrieveOrRegisterProxy(InitialDataProxy) as InitialDataProxy;
			eventTemplateProxy = (facade as ApplicationFacade).retrieveOrRegisterProxy(EventTemplateProxy) as EventTemplateProxy;
			sessionTemplateProxy = (facade as ApplicationFacade).retrieveOrRegisterProxy(SessionTemplateProxy) as SessionTemplateProxy;
		}
		
		protected function get createEventFromTemplateDialog():ICreateEventFromTemplateDialog
		{
			return viewComponent as ICreateEventFromTemplateDialog;
		}
		
		override public function listNotificationInterests():Array
		{
			var ret:Array = super.listNotificationInterests();
			ret.push(NotificationNames.DIALOGPRESENTED);
			ret.push(NotificationNames.LOGOUT);
			ret.push(NotificationNames.RECEIVEDONE);
			ret.push(NotificationNames.UPDATESESSIONTEMPLATES);
			return ret;
		}
		
		override protected function populate():void
		{
			if (inputCollector != null)
				inputCollector.removeEventListener(Event.COMPLETE, onInputsCollected);
			inputCollector = new InputCollector(['event_template', 'session_templates']);
			inputCollector.addEventListener(Event.COMPLETE, onInputsCollected);
			
			eventTemplateProxy.findByPK(initialDataProxy.getInitialData(Places.CREATEEVENTFROMTEMPLATE) as Number);
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case NotificationNames.DIALOGPRESENTED:
					var body:String = notification.getBody() as String;
					if (body != null && body == Places.CREATEEVENTFROMTEMPLATE)
						populate();
					break;
				
				case NotificationNames.LOGOUT:
					createDialog.clear();
					break;
				
				case NotificationNames.UPDATESESSIONTEMPLATES:
					inputCollector.addInput('session_templates', (notification.getBody() as DataSet).toArray());
					waitingForSessionTemplates = false;
					break;
				
				case NotificationNames.RECEIVEDONE:
					if (notification.getType() == eventTemplateProxy.getProxyName())
					{
						var template:Object = notification.getBody();
						inputCollector.addInput('event_template', template);
						waitingForSessionTemplates = true;
						sessionTemplateProxy.findByIDs(template['session_templates']);
					}
					break;
				
				default:
					super.handleNotification(notification);
			}
		}
		
		protected function onInputsCollected(event:Event):void
		{
			var inputCollector:InputCollector = event.target as InputCollector;
			createEventFromTemplateDialog.populate(inputCollector.object['event_template'], inputCollector.object['session_templates']);
		}
	}
}