package net.poweru.presenters
{
	import flash.events.Event;
	
	import mx.events.FlexEvent;
	
	import net.poweru.ApplicationFacade;
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.components.interfaces.IOrganizations;
	import net.poweru.events.ViewEvent;
	import net.poweru.model.DataSet;
	import net.poweru.proxies.AdminOrganizationViewProxy;
	import net.poweru.proxies.UserOrgRoleProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;

	public class OrganizationsMediator extends BaseMediator implements IMediator
	{
		public static const NAME:String = 'OrganizationsMediator';
		
		protected var userOrgRoleProxy:UserOrgRoleProxy;
		/*	holds a serialized version of our filters, so that when results
			arrive, we can determine if they match our most recent request. */
		protected var mostRecentFilterString:String;
		
		public function OrganizationsMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, AdminOrganizationViewProxy);
			userOrgRoleProxy = (facade as ApplicationFacade).retrieveOrRegisterProxy(UserOrgRoleProxy) as UserOrgRoleProxy;
		}
		
		protected function get organizations():IOrganizations
		{
			return viewComponent as IOrganizations;
		}
		
		protected function get adminOrganizationsViewProxy():AdminOrganizationViewProxy
		{
			return primaryProxy as AdminOrganizationViewProxy;
		}
		
		override protected function addEventListeners():void
		{
			displayObject.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			displayObject.addEventListener(ViewEvent.REFRESH, onRefresh);
			displayObject.addEventListener(ViewEvent.SHOWDIALOG, onShowDialog);
			displayObject.addEventListener(ViewEvent.SUBMIT, onSubmit);
			displayObject.addEventListener(ViewEvent.FETCH, onFetch);
		}
		
		override protected function removeEventListeners():void
		{
			displayObject.removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);	
			displayObject.removeEventListener(ViewEvent.REFRESH, onRefresh);
			displayObject.removeEventListener(ViewEvent.SHOWDIALOG, onShowDialog);
			displayObject.removeEventListener(ViewEvent.SUBMIT, onSubmit);
			displayObject.removeEventListener(ViewEvent.FETCH, onFetch);
		}
		
		override public function listNotificationInterests():Array
		{
			return super.listNotificationInterests().concat(
				NotificationNames.SETSPACE,
				NotificationNames.UPDATEORGANIZATIONS,
				NotificationNames.UPDATEORGEMAILDOMAINS,
				NotificationNames.UPDATEADMINORGANIZATIONSVIEW,
				NotificationNames.UPDATEUSERORGROLES
			);
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case NotificationNames.UPDATEUSERORGROLES:
					/*	if the filters match a fetch for a whole org, populate the
						users. Otherwise this is probably the result of having
						updated a userorgrole, in which case we need to refresh. */
					if (notification.getType() == mostRecentFilterString)
						organizations.populateUsers((notification.getBody() as DataSet).toArray());
					else
						populate();
					break;
				
				case NotificationNames.SETSPACE:
					if (notification.getBody() == Places.ORGANIZATIONS)
						clearableComponent.clear();
						populate();
					break;
					
				// Happens when we save an org, and indicates that we should just refresh the view
				case NotificationNames.UPDATEORGANIZATIONS:
				case NotificationNames.UPDATEORGEMAILDOMAINS:
					populate();
					break;
					
				case NotificationNames.UPDATEADMINORGANIZATIONSVIEW:
					arrayPopulatedComponent.populate(notification.getBody() as Array);
					break;
				
				default:
					super.handleNotification(notification);
			}
		}
		
		override protected function populate():void
		{
			adminOrganizationsViewProxy.adminOrganizationsView();
			mostRecentFilterString = '';
		}
		
		protected function onSubmit(event:ViewEvent):void
		{
			primaryProxy.save(event.body);
		}
		
		protected function onFetch(event:ViewEvent):void
		{
			var filters:Object = {'exact': {'organization':event.body as Number}};
			mostRecentFilterString = filters.toString();
			userOrgRoleProxy.getFiltered(filters);
		}
	}
}