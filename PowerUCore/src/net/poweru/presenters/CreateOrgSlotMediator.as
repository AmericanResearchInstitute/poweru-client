package net.poweru.presenters
{
	import flash.events.Event;
	
	import net.poweru.ApplicationFacade;
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.components.interfaces.ICreateOrgSlot;
	import net.poweru.events.ViewEvent;
	import net.poweru.model.DataSet;
	import net.poweru.placemanager.InitialDataProxy;
	import net.poweru.proxies.OrgRoleProxy;
	import net.poweru.proxies.OrganizationProxy;
	import net.poweru.proxies.UserOrgRoleProxy;
	import net.poweru.utils.InputCollector;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class CreateOrgSlotMediator extends BaseCreateDialogMediator implements IMediator
	{
		public static const NAME:String = 'CreateOrgSlotMediator';
		
		protected var orgRoleProxy:OrgRoleProxy;
		protected var initialDataProxy:InitialDataProxy;
		protected var organizationProxy:OrganizationProxy;
		protected var inputCollector:InputCollector;
		
		public function CreateOrgSlotMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, UserOrgRoleProxy);
			init();
		}
		
		private function init():void
		{
			orgRoleProxy = getProxy(OrgRoleProxy) as OrgRoleProxy;
			organizationProxy = getProxy(OrganizationProxy) as OrganizationProxy;
			initialDataProxy = getProxy(InitialDataProxy) as InitialDataProxy;
		}
		
		protected function get createOrgSlot():ICreateOrgSlot
		{
			return viewComponent as ICreateOrgSlot;
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				NotificationNames.LOGOUT,
				NotificationNames.DIALOGPRESENTED,
				NotificationNames.RECEIVEDONE,
				NotificationNames.UPDATEORGROLES,
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case NotificationNames.LOGOUT:
					if (createDialog)
						createDialog.clear();
					break;
				
				case NotificationNames.DIALOGPRESENTED:
					var body:String = notification.getBody() as String;
					if (body != null && body == Places.CREATEORGANIZATIONSLOT)
						populate();
					break;
				
				case NotificationNames.RECEIVEDONE:
					if (notification.getType() == organizationProxy.getProxyName())
						inputCollector.addInput('organization', notification.getBody());
					break;
				
				case NotificationNames.UPDATEORGROLES:
					inputCollector.addInput('roles', (notification.getBody() as DataSet).toArray());
					break;
			}
		}
		
		override protected function populate():void
		{
			if (inputCollector != null)
				inputCollector.removeEventListener(Event.COMPLETE, onInputsCollected);
			inputCollector = new InputCollector(['roles', 'organization']);
			inputCollector.addEventListener(Event.COMPLETE, onInputsCollected);
			orgRoleProxy.getAll();
			organizationProxy.getOne(initialDataProxy.getInitialData(Places.CREATEORGANIZATIONSLOT) as Number);
		}
		
		protected function onInputsCollected(event:Event):void
		{
			createOrgSlot.populate(inputCollector.object['roles'], inputCollector.object['organization']);
		}
		
		// fetch roles and provide them to setChoices()
	}
}