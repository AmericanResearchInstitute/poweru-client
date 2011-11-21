package net.poweru.presenters
{
	import flash.events.Event;
	
	import net.poweru.ApplicationFacade;
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.events.ViewEvent;
	import net.poweru.model.DataSet;
	import net.poweru.presenters.BaseEditDialogMediator;
	import net.poweru.proxies.AdminUsersViewProxy;
	import net.poweru.proxies.GroupProxy;
	import net.poweru.proxies.OrgRoleProxy;
	import net.poweru.proxies.OrganizationProxy;
	import net.poweru.proxies.UserProxy;
	import net.poweru.utils.InputCollector;
	import net.poweru.utils.PKArrayCollection;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;

	public class EditUserMediator extends BaseEditDialogMediator implements IMediator
	{
		public static const NAME:String = 'EditUserMediator';
		
		protected var groupProxy:GroupProxy;
		protected var organizationProxy:OrganizationProxy;
		protected var orgRoleProxy:OrgRoleProxy;
		protected var userProxy:UserProxy;
		protected var inputCollector:InputCollector;
		
		public function EditUserMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, AdminUsersViewProxy, Places.EDITUSER);
			userProxy = (facade as ApplicationFacade).retrieveOrRegisterProxy(UserProxy) as UserProxy;
			groupProxy = (facade as ApplicationFacade).retrieveOrRegisterProxy(GroupProxy) as GroupProxy;
			organizationProxy = (facade as ApplicationFacade).retrieveOrRegisterProxy(OrganizationProxy) as OrganizationProxy;
			orgRoleProxy = (facade as ApplicationFacade).retrieveOrRegisterProxy(OrgRoleProxy) as OrgRoleProxy;
			// placeholder
			inputCollector = new InputCollector([]);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				NotificationNames.DIALOGPRESENTED,
				NotificationNames.LOGOUT,
				NotificationNames.RECEIVEDONE,
				NotificationNames.STATECHANGE,
				NotificationNames.UPDATECHOICES,
				NotificationNames.UPDATEGROUPS,
				NotificationNames.UPDATEORGANIZATIONS,
				NotificationNames.UPDATEORGROLES
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case NotificationNames.LOGOUT:
					if (editDialog)
						editDialog.clear();
					break;
					
				case NotificationNames.DIALOGPRESENTED:
					var body:String = notification.getBody() as String;
					if (body != null && body == Places.EDITUSER)
					{
						editDialog.setState(loginProxy.applicationState);
						populate();
					}
					break;
					
				case NotificationNames.RECEIVEDONE:
					if (notification.getType() == primaryProxy.getProxyName())
						inputCollector.addInput('userData', notification.getBody());
					break;
				
				case NotificationNames.STATECHANGE:
					if (editDialog)
						editDialog.setState(notification.getBody() as String);
					break;
					
				case NotificationNames.UPDATECHOICES:
					if (notification.getType() == primaryProxy.getProxyName())
						inputCollector.addInput('choices', notification.getBody());
					break;
				
				case NotificationNames.UPDATEGROUPS:
					var groups:DataSet = notification.getBody() as DataSet;
					inputCollector.addInput('groups', groups.toArray());
					break;
					
				case NotificationNames.UPDATEORGANIZATIONS:
					var orgs:DataSet = notification.getBody() as DataSet;
					inputCollector.addInput('organizations', orgs.toArray());
					break;
				
				case NotificationNames.UPDATEORGROLES:
					var orgRoles:DataSet = notification.getBody() as DataSet;
					inputCollector.addInput('organization_roles', orgRoles.toArray());
					break;
			}
		}
		
		override protected function onSubmit(event:ViewEvent):void
		{
			var newObject:Object = event.body;
			newObject['groups'] = new PKArrayCollection(newObject['groups']).toArray();
			if (newObject.hasOwnProperty('password'))
			{
				userProxy.changePassword(newObject['id'], newObject['password'], newObject['oldPassword']);
				delete newObject['password'];
				delete newObject['oldPassword'];
			}
			primaryProxy.save(newObject);
			sendNotification(NotificationNames.REMOVEDIALOG, displayObject);
		}
		
		override protected function populate():void
		{
			if (inputCollector)
				inputCollector.removeEventListener(Event.COMPLETE, onInputsCollected);
				
			inputCollector = new InputCollector(['userData', 'groups', 'choices', 'organizations', 'organization_roles']);
			inputCollector.addEventListener(Event.COMPLETE, onInputsCollected);
			var pk:Number = initialDataProxy.getInitialData(placeName) as Number;
			// If no PK was specified, assume we want the current user
			if (pk <= 0)
				pk = loginProxy.currentUser['id'];
			primaryProxy.findByPK(pk);
			groupProxy.getAll();
			organizationProxy.getAll();
			orgRoleProxy.getAll();
			primaryProxy.getChoices();
		}
		
		protected function onInputsCollected(event:Event):void
		{
			var collector:InputCollector = event.target as InputCollector;
			editDialog.setChoices(collector.object['choices']);
			editDialog.populate(collector.object['userData'], collector.object['groups'] as Array, collector.object['organizations'] as Array, collector.object['organization_roles'] as Array);
		}
		
	}
}