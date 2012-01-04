package net.poweru.presenters
{
	import flash.events.Event;
	
	import net.poweru.ApplicationFacade;
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.components.interfaces.ICreateSessionUserRoleRequirementDialog;
	import net.poweru.placemanager.InitialDataProxy;
	import net.poweru.placemanager.PlaceNotFound;
	import net.poweru.proxies.SessionUserRoleProxy;
	import net.poweru.proxies.SessionUserRoleRequirementProxy;
	import net.poweru.utils.InputCollector;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class CreateSessionUserRoleRequirementMediator extends BaseCreateDialogMediator implements IMediator
	{
		public static const NAME:String = 'CreateSessionUserRoleRequirementMediator';
		
		protected var inputCollector:InputCollector;
		protected var initialDataProxy:InitialDataProxy;
		protected var sessionUserRoleProxy:SessionUserRoleProxy;
		
		public function CreateSessionUserRoleRequirementMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, SessionUserRoleRequirementProxy);
			
			initialDataProxy = (facade as ApplicationFacade).retrieveOrRegisterProxy(InitialDataProxy) as InitialDataProxy;
			sessionUserRoleProxy = (facade as ApplicationFacade).retrieveOrRegisterProxy(SessionUserRoleProxy) as SessionUserRoleProxy;
		}
		
		override public function listNotificationInterests():Array
		{
			var ret:Array = super.listNotificationInterests();
			ret.push(NotificationNames.DIALOGPRESENTED);
			ret.push(NotificationNames.UPDATESESSIONUSERROLES);
			return ret;
		}
		
		protected function get createSURRDialog():ICreateSessionUserRoleRequirementDialog
		{
			return displayObject as ICreateSessionUserRoleRequirementDialog;
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case NotificationNames.DIALOGPRESENTED:
					if (notification.getBody() == Places.CREATESESSIONUSERROLEREQUIREMENT)
						populate();
					break;
				
				case NotificationNames.UPDATESESSIONUSERROLES:
					inputCollector.addInput('session_user_roles', sessionUserRoleProxy.dataSet.toArray());
					break;
				
				default:
					super.handleNotification(notification);
			}
		}
		
		override protected function populate():void
		{
			if (inputCollector != null)
				inputCollector.removeEventListener(Event.COMPLETE, onInputsCollected);
			inputCollector = new InputCollector(['session', 'session_user_roles']);
			inputCollector.addEventListener(Event.COMPLETE, onInputsCollected);
			
			sessionUserRoleProxy.getAll();
			inputCollector.addInput('session', initialDataProxy.getInitialData(Places.CREATESESSIONUSERROLEREQUIREMENT));
		}
		
		protected function onInputsCollected(event:Event):void
		{
			createSURRDialog.populate(inputCollector.object['session'], inputCollector.object['session_user_roles']);
		}
	}
}