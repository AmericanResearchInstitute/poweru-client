package net.poweru.presenters
{
	import net.poweru.ApplicationFacade;
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.components.interfaces.IUsers;
	import net.poweru.events.ViewEvent;
	import net.poweru.model.DataSet;
	import net.poweru.presenters.BaseMediator;
	import net.poweru.proxies.AdminOrganizationViewProxy;
	import net.poweru.proxies.GroupProxy;
	import net.poweru.proxies.OrgRoleProxy;
	import net.poweru.proxies.UserProxy;
	import net.poweru.utils.InputCollector;
	
	import flash.events.Event;
	
	import mx.events.FlexEvent;
	import mx.utils.ObjectUtil;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;

	public class UsersMediator extends BaseMediator implements IMediator
	{
		public static var NAME:String = 'UsersMediator';
		
		protected var populatedSinceLastClear:Boolean = false;
		protected var groupProxy:GroupProxy;
		protected var adminOrganizationViewProxy:AdminOrganizationViewProxy;
		protected var inputCollector:InputCollector;
		protected var orgRoleProxy:OrgRoleProxy;
		
		public function UsersMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent, UserProxy);
			groupProxy = (facade as ApplicationFacade).retrieveOrRegisterProxy(GroupProxy) as GroupProxy;
			adminOrganizationViewProxy = (facade as ApplicationFacade).retrieveOrRegisterProxy(AdminOrganizationViewProxy) as AdminOrganizationViewProxy;
			orgRoleProxy = (facade as ApplicationFacade).retrieveOrRegisterProxy(OrgRoleProxy) as OrgRoleProxy;
		}
		
		protected function get userProxy():UserProxy
		{
			return primaryProxy as UserProxy;
		}
		
		override protected function addEventListeners():void
		{
			displayObject.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			displayObject.addEventListener(ViewEvent.SHOWDIALOG, onShowDialog);
			displayObject.addEventListener(ViewEvent.REFRESH, onRefresh);
			displayObject.addEventListener(ViewEvent.SUBMIT, onSubmit);
		}
		
		override protected function removeEventListeners():void
		{
			displayObject.removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			displayObject.removeEventListener(ViewEvent.SHOWDIALOG, onShowDialog);
			displayObject.removeEventListener(ViewEvent.REFRESH, onRefresh);
			displayObject.removeEventListener(ViewEvent.SUBMIT, onSubmit);
		}
		
		protected function get users():IUsers
		{
			return viewComponent as IUsers;
		}
	
		override public function listNotificationInterests():Array
		{
			return [
				NotificationNames.LOGOUT,
				NotificationNames.SETSPACE,
				NotificationNames.UPDATEADMINORGANIZATIONSVIEW,
				NotificationNames.UPDATEADMINUSERSVIEW,
				NotificationNames.UPDATECHOICES,
				NotificationNames.UPDATEGROUPS,
				NotificationNames.UPDATEORGROLES,
				NotificationNames.UPDATEUSERS,
				];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case NotificationNames.LOGOUT:
					users.clear();
					populatedSinceLastClear = false;
					break;
					
				case NotificationNames.SETSPACE:
					if (notification.getBody() == Places.USERS && !populatedSinceLastClear)
						populate();
					break;
				
				// Happens when we save a user, and indicates that we should just refresh the view
				case NotificationNames.UPDATEUSERS:
					populate();
					break;
					
				case NotificationNames.UPDATEADMINORGANIZATIONSVIEW:
					inputCollector.addInput('organizations', ObjectUtil.copy(notification.getBody()));
					break;
					
				case NotificationNames.UPDATEADMINUSERSVIEW:
					inputCollector.addInput('users', ObjectUtil.copy(notification.getBody()));
					break;
					
				case NotificationNames.UPDATECHOICES:
					if (notification.getType() == UserProxy.NAME && inputCollector != null)
						inputCollector.addInput('choices', ObjectUtil.copy(notification.getBody()));
					break;
				
				case NotificationNames.UPDATEGROUPS:
					var groups:DataSet = notification.getBody() as DataSet;
					inputCollector.addInput('groups', ObjectUtil.copy(groups.toArray()));
					break;
					
				case NotificationNames.UPDATEORGROLES:
					var ds:DataSet = notification.getBody() as DataSet;
					inputCollector.addInput('orgRoles', ObjectUtil.copy(ds.toArray()));
					break;
			}
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			displayObject.removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			populate();
		}
		
		protected function onRefresh(event:ViewEvent):void
		{
			primaryProxy.clear();
			populate();
		}
		
		protected function onInputsCollected(event:Event):void
		{
			populatedSinceLastClear = true;
			
			var inputCollector:InputCollector = event.target as InputCollector;
			users.populate(inputCollector.object['users'], inputCollector.object['organizations'], inputCollector.object['orgRoles'], inputCollector.object['groups'], inputCollector.object['choices']);
		}
		
		protected function onSubmit(event:ViewEvent):void
		{
			primaryProxy.save(event.body);
		}
		
		protected function populate():void
		{
			if (inputCollector)
				inputCollector.removeEventListener(Event.COMPLETE, onInputsCollected);
			inputCollector = new InputCollector(['users', 'organizations', 'orgRoles', 'groups', 'choices']);
			inputCollector.addEventListener(Event.COMPLETE, onInputsCollected);
			
			userProxy.adminUsersView();
			userProxy.getChoices();
			adminOrganizationViewProxy.adminOrganizationsView();
			orgRoleProxy.getAll(['name']);
			groupProxy.getAll(['name']);
		}
		
	}
}