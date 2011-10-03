package net.poweru.presenters
{
	import flash.events.Event;
	
	import net.poweru.ApplicationFacade;
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.model.DataSet;
	import net.poweru.proxies.SessionProxy;
	import net.poweru.proxies.SessionUserRoleProxy;
	import net.poweru.utils.InputCollector;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class EditSessionMediator extends BaseEditDialogMediator implements IMediator
	{
		public static const NAME:String = 'EditSessionMediator';
		
		protected var inputCollector:InputCollector;
		protected var sessionUserRoleProxy:SessionUserRoleProxy;
		
		public function EditSessionMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, SessionProxy, Places.EDITSESSION);
			sessionUserRoleProxy = (facade as ApplicationFacade).retrieveOrRegisterProxy(SessionUserRoleProxy) as SessionUserRoleProxy;
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				NotificationNames.LOGOUT,
				NotificationNames.DIALOGPRESENTED,
				NotificationNames.RECEIVEDONE,
				NotificationNames.UPDATESESSIONUSERROLES
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case NotificationNames.RECEIVEDONE:
					if (notification.getType() == primaryProxy.getProxyName())
						inputCollector.addInput('session', notification.getBody());
					break;
				
				case NotificationNames.UPDATESESSIONUSERROLES:
					inputCollector.addInput('session_user_roles', (notification.getBody() as DataSet).toArray());
					break;
				
				default:
					super.handleNotification(notification);
			}
		}
		
		override protected function populate():void
		{
			if (inputCollector)
				inputCollector.removeEventListener(Event.COMPLETE, onInputsCollected);
			inputCollector = new InputCollector(['session', 'session_user_roles']);
			inputCollector.addEventListener(Event.COMPLETE, onInputsCollected);
			
			primaryProxy.findByPK(initialDataProxy.getInitialData(placeName) as Number);
			sessionUserRoleProxy.getAll();
		}
		
		protected function onInputsCollected(event:Event):void
		{
			var inputCollector:InputCollector = event.target as InputCollector;
			editDialog.populate(inputCollector.object['session'], inputCollector.object['session_user_roles']);
		}
	}
}