package net.poweru.presenters
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	import net.poweru.ApplicationFacade;
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.model.DataSet;
	import net.poweru.proxies.OrgRoleProxy;
	import net.poweru.proxies.UserOrgRoleProxy;
	import net.poweru.utils.InputCollector;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class EditUserOrgRoleMediator extends BaseEditDialogMediator implements IMediator
	{
		public static const NAME:String = 'EditUserOrgRoleMediator';
		
		protected var inputCollector:InputCollector;
		protected var orgRoleProxy:OrgRoleProxy;
		
		public function EditUserOrgRoleMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, UserOrgRoleProxy, Places.EDITUSERORGROLE);
			orgRoleProxy = (facade as ApplicationFacade).retrieveOrRegisterProxy(OrgRoleProxy) as OrgRoleProxy;
		}
		
		override public function listNotificationInterests():Array
		{
			var ret:Array = super.listNotificationInterests();
			ret = ret.concat([
				NotificationNames.UPDATEORGROLES
			]);
			return ret;
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{	
				case NotificationNames.CHOICEMADE:
					if (notification.getType() == Places.CHOOSEUSER)
						editDialog.receiveChoice(notification.getBody(), notification.getType());
					break;
				
				case NotificationNames.UPDATEORGROLES:
					var roles:DataSet = notification.getBody() as DataSet;
					inputCollector.addInput('roles', roles.toArray());
					break;
				
				default:
					super.handleNotification(notification);
			}
		}
		
		override protected function onReceivedOne(notification:INotification):void
		{
			inputCollector.addInput('user_org_role', notification.getBody());
		}
		
		override protected function populate():void
		{
			if (inputCollector)
				inputCollector.removeEventListener(Event.COMPLETE, onInputsCollected);
			inputCollector = new InputCollector(['user_org_role', 'roles']);
			inputCollector.addEventListener(Event.COMPLETE, onInputsCollected);
			
			primaryProxy.findByPK(initialDataProxy.getInitialData(placeName) as Number);
			// Need to fetch roles before actually populating.
			orgRoleProxy.getAll();
		}
		
		protected function onInputsCollected(event:Event):void
		{
			var inputCollector:InputCollector = event.target as InputCollector;
			editDialog.populate(inputCollector.object['user_org_role'], inputCollector.object['roles']);
		}
	}
}