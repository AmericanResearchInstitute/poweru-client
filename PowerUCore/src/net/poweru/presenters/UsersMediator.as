package net.poweru.presenters
{
	import flash.events.Event;
	
	import mx.events.FlexEvent;
	import mx.utils.ObjectUtil;
	
	import net.poweru.ApplicationFacade;
	import net.poweru.Constants;
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.components.interfaces.IUsers;
	import net.poweru.events.ViewEvent;
	import net.poweru.model.DataSet;
	import net.poweru.presenters.BaseMediator;
	import net.poweru.proxies.AdminOrganizationViewProxy;
	import net.poweru.proxies.AdminUsersViewProxy;
	import net.poweru.proxies.AssignmentProxy;
	import net.poweru.proxies.CurriculumEnrollmentProxy;
	import net.poweru.proxies.EventProxy;
	import net.poweru.proxies.GroupProxy;
	import net.poweru.proxies.OrgRoleProxy;
	import net.poweru.proxies.UserProxy;
	import net.poweru.utils.InputCollector;
	
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
		protected var curriculumEnrollmentProxy:CurriculumEnrollmentProxy;
		protected var eventProxy:EventProxy;
		protected var assignmentProxy:AssignmentProxy;
		
		public function UsersMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent, AdminUsersViewProxy);
			groupProxy = (facade as ApplicationFacade).retrieveOrRegisterProxy(GroupProxy) as GroupProxy;
			adminOrganizationViewProxy = (facade as ApplicationFacade).retrieveOrRegisterProxy(AdminOrganizationViewProxy) as AdminOrganizationViewProxy;
			orgRoleProxy = (facade as ApplicationFacade).retrieveOrRegisterProxy(OrgRoleProxy) as OrgRoleProxy;
			curriculumEnrollmentProxy = (facade as ApplicationFacade).retrieveOrRegisterProxy(CurriculumEnrollmentProxy) as CurriculumEnrollmentProxy;
			eventProxy = (facade as ApplicationFacade).retrieveOrRegisterProxy(EventProxy) as EventProxy;
			assignmentProxy = (facade as ApplicationFacade).retrieveOrRegisterProxy(AssignmentProxy) as AssignmentProxy;
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
				NotificationNames.CHOICEMADE,
				NotificationNames.LOGOUT,
				NotificationNames.SETSPACE,
				NotificationNames.UPDATEADMINORGANIZATIONSVIEW,
				NotificationNames.UPDATEADMINUSERSVIEW,
				NotificationNames.UPDATECHOICES,
				NotificationNames.UPDATECURRICULUMENROLLMENTS,
				NotificationNames.UPDATECURRICULUMENROLLMENTSVIEW,
				NotificationNames.UPDATEGROUPS,
				NotificationNames.UPDATEORGROLES,
				NotificationNames.UPDATEUSERS,
				NotificationNames.UPDATEEVENTS
				];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case NotificationNames.CHOICEMADE:
					users.receiveChoice(notification.getBody(), notification.getType());
					break;
					
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
					inputCollector.addInput('users', ObjectUtil.copy(primaryProxy.dataSet.toArray()));
					break;
					
				case NotificationNames.UPDATECHOICES:
					if (notification.getType() == primaryProxy.getProxyName() && inputCollector != null)
						inputCollector.addInput('choices', ObjectUtil.copy(notification.getBody()));
					break;
				
				case NotificationNames.UPDATECURRICULUMENROLLMENTS:
					curriculumEnrollmentProxy.curriculumEnrollmentsView();
					break;
				
				case NotificationNames.UPDATECURRICULUMENROLLMENTSVIEW:
					inputCollector.addInput('curriculumEnrollments', ObjectUtil.copy(notification.getBody()));
					break;
				
				case NotificationNames.UPDATEEVENTS:
					inputCollector.addInput('events', ObjectUtil.copy((notification.getBody() as DataSet).toArray()));
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
		
		protected function onInputsCollected(event:Event):void
		{
			populatedSinceLastClear = true;
			
			var inputCollector:InputCollector = event.target as InputCollector;
			users.populate(inputCollector.object['users'], inputCollector.object['organizations'], inputCollector.object['orgRoles'], inputCollector.object['groups'], inputCollector.object['choices'], inputCollector.object['curriculumEnrollments'], inputCollector.object['events']);
		}
		
		protected function onSubmit(event:ViewEvent):void
		{
			switch (event.subType)
			{
				case Constants.BULKASSIGN:
					assignmentProxy.bulkCreate(event.body.task, event.body.users);
					break;
				
				case Constants.CURRICULUMENROLLMENT:
					curriculumEnrollmentProxy.save(event.body);
					break;
				
				default:
					primaryProxy.save(event.body);
			}	
		}
		
		override protected function populate():void
		{
			if (inputCollector)
				inputCollector.removeEventListener(Event.COMPLETE, onInputsCollected);
			inputCollector = new InputCollector(['users', 'organizations', 'orgRoles', 'groups', 'choices', 'curriculumEnrollments', 'events']);
			inputCollector.addEventListener(Event.COMPLETE, onInputsCollected);
			
			primaryProxy.getAll();
			primaryProxy.getChoices();
			adminOrganizationViewProxy.adminOrganizationsView();
			orgRoleProxy.getAll();
			groupProxy.getAll();
			curriculumEnrollmentProxy.curriculumEnrollmentsView();
			eventProxy.getAll();
		}
		
	}
}