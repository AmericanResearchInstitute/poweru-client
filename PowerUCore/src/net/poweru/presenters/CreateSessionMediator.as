package net.poweru.presenters
{
	import net.poweru.ApplicationFacade;
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.components.interfaces.ICreateSession;
	import net.poweru.placemanager.InitialDataProxy;
	import net.poweru.proxies.EventProxy;
	import net.poweru.proxies.SessionProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class CreateSessionMediator extends BaseCreateDialogMediator implements IMediator
	{
		public static const NAME:String = 'CreateSessionMediator';
		
		protected var initialDataProxy:InitialDataProxy;
		protected var eventProxy:EventProxy;
		
		public function CreateSessionMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, SessionProxy);
			init();
		}
		
		private function init():void
		{
			initialDataProxy = getProxy(InitialDataProxy) as InitialDataProxy;
			eventProxy = getProxy(EventProxy) as EventProxy;
		}
		
		override public function listNotificationInterests():Array
		{
			var ret:Array = super.listNotificationInterests();
			ret.push(NotificationNames.DIALOGPRESENTED);
			ret.push(NotificationNames.RECEIVEDONE);
			return ret;
		}
		
		protected function get createSessionDialog():ICreateSession
		{
			return displayObject as ICreateSession;
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case NotificationNames.DIALOGPRESENTED:
					if (notification.getBody() == Places.CREATESESSION)
						populate();
					break;
				
				case NotificationNames.RECEIVEDONE:
					if (notification.getType() == EventProxy.NAME)
						createSessionDialog.populateEventData(notification.getBody());
					break;
				
				default:
					super.handleNotification(notification);
			}
		}
		
		override protected function populate():void
		{
			eventProxy.findByPK(initialDataProxy.getInitialData(Places.CREATESESSION) as Number);
		}
	}
}