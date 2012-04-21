package net.poweru.presenters
{
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.components.interfaces.ICreateSessionTemplate;
	import net.poweru.placemanager.InitialDataProxy;
	import net.poweru.proxies.EventTemplateProxy;
	import net.poweru.proxies.SessionTemplateProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class CreateSessionTemplateMediator extends BaseCreateDialogMediator implements IMediator
	{
		public static const NAME:String = 'CreateSessionTemplateMediator';
		
		protected var eventTemplateProxy:EventTemplateProxy;
		protected var initialDataProxy:InitialDataProxy;
		
		public function CreateSessionTemplateMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, SessionTemplateProxy);
			init();
		}
		
		private function init():void
		{
			eventTemplateProxy = getProxy(EventTemplateProxy) as EventTemplateProxy;
			initialDataProxy = getProxy(InitialDataProxy) as InitialDataProxy;
		}
		
		protected function get createSTDialog():ICreateSessionTemplate
		{
			return viewComponent as ICreateSessionTemplate;
		}
		
		override public function listNotificationInterests():Array
		{
			var ret:Array = super.listNotificationInterests();
			ret.push(NotificationNames.DIALOGPRESENTED);
			ret.push(NotificationNames.RECEIVEDONE);
			return ret;
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case NotificationNames.DIALOGPRESENTED:
					if (notification.getBody() == Places.CREATESESSIONTEMPLATE)
						populate();
					break;
				
				case NotificationNames.RECEIVEDONE:
					if (notification.getType() == EventTemplateProxy.NAME)
						createSTDialog.populateEventTemplateData(notification.getBody());
					break;
				
				default:
					super.handleNotification(notification);
			}
		}
		
		override protected function populate():void
		{
			eventTemplateProxy.findByPK(initialDataProxy.getInitialData(Places.CREATESESSIONTEMPLATE) as Number);
		}
	}
}