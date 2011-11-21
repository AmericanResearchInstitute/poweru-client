package net.poweru.presenters
{
	import flash.events.Event;
	
	import net.poweru.ApplicationFacade;
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.model.DataSet;
	import net.poweru.proxies.OrganizationProxy;
	import net.poweru.proxies.UserProxy;
	import net.poweru.utils.InputCollector;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class ChooseUserMediator extends BaseChooserMediator implements IMediator
	{
		public static const NAME:String = 'ChooseUserMediator';
		
		protected var organizationProxy:OrganizationProxy;
		protected var inputCollector:InputCollector;
		
		public function ChooseUserMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, Places.CHOOSEUSER, NotificationNames.UPDATEUSERS, UserProxy);
			organizationProxy = (facade as ApplicationFacade).retrieveOrRegisterProxy(OrganizationProxy) as OrganizationProxy;
		}
		
		override protected function populate():void
		{
			if (inputCollector != null)
				inputCollector.removeEventListener(Event.COMPLETE, onInputsCollected);
			inputCollector = new InputCollector(['users', 'organizations', 'user_status_choices']);
			inputCollector.addEventListener(Event.COMPLETE, onInputsCollected);
			
			primaryProxy.getAll();
			primaryProxy.getChoices();
			organizationProxy.getAll();
		}
		
		override public function listNotificationInterests():Array
		{
			var ret:Array = super.listNotificationInterests();
			ret = ret.concat(
				NotificationNames.LOGOUT,
				NotificationNames.UPDATECHOICES,
				NotificationNames.UPDATEORGANIZATIONS
			);
			return ret;
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case NotificationNames.SHOWDIALOG:
					if (notification.getBody()[0] == placeName)
						populate();
					break;
				
				case NotificationNames.UPDATECHOICES:
					if (notification.getType() == primaryProxy.getProxyName())
						inputCollector.addInput('user_status_choices', notification.getBody()['status']);
					break;
				
				case updateNotification:
					inputCollector.addInput('users', (notification.getBody() as DataSet).toArray());
					break;
				
				case NotificationNames.UPDATEORGANIZATIONS:
					inputCollector.addInput('organizations', (notification.getBody() as DataSet).toArray());
					break;
				
				default:
					super.handleNotification(notification);
			}
		}
		
		protected function onInputsCollected(event:Event):void
		{
			chooser.populate(
				inputCollector.object['users'],
				inputCollector.object['user_status_choices'],
				inputCollector.object['organizations']
			);
		}
	}
}