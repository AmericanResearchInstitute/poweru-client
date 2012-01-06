package net.poweru.presenters
{
	import flash.events.Event;
	
	import net.poweru.ApplicationFacade;
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.proxies.SessionUserRoleProxy;
	import net.poweru.proxies.SessionUserRoleRequirementProxy;
	import net.poweru.utils.InputCollector;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class EditSessionUserRoleRequirementMediator extends BaseEditDialogMediator implements IMediator
	{
		public static const NAME:String = 'EditSessionUserRoleRequirementMediator';
		
		protected var inputCollector:InputCollector;
		protected var sessionUserRoleProxy:SessionUserRoleProxy;
		
		public function EditSessionUserRoleRequirementMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, SessionUserRoleRequirementProxy, Places.EDITSESSIONUSERROLEREQUIREMENT);
			sessionUserRoleProxy = (facade as ApplicationFacade).retrieveOrRegisterProxy(SessionUserRoleProxy) as SessionUserRoleProxy;
		}
		
		override public function listNotificationInterests():Array
		{
			var ret:Array = super.listNotificationInterests();
			ret.push(NotificationNames.UPDATESESSIONUSERROLES);
			return ret;
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
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
			inputCollector = new InputCollector(['surr', 'session_user_roles']);
			inputCollector.addEventListener(Event.COMPLETE, onInputsCollected);
			
			super.populate();
			sessionUserRoleProxy.getAll();
		}
		
		protected function onInputsCollected(event:Event):void
		{
			editDialog.populate(inputCollector.object['surr'], inputCollector.object['session_user_roles']);
		}
		
		override protected function onReceivedOne(notification:INotification):void
		{
			inputCollector.addInput('surr', notification.getBody());
		}
	}
}