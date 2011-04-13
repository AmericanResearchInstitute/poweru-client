package net.poweru.presenters
{
	import flash.events.Event;
	
	import mx.events.FlexEvent;
	
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.components.interfaces.IOrganizations;
	import net.poweru.events.ViewEvent;
	import net.poweru.proxies.AdminOrganizationViewProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;

	public class OrganizationsMediator extends BaseMediator implements IMediator
	{
		public static const NAME:String = 'OrganizationsMediator';
		
		public function OrganizationsMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, AdminOrganizationViewProxy);
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
			return [
				NotificationNames.ADMINORGANIZATIONUSERSVIEW,
				NotificationNames.SETSPACE,
				NotificationNames.UPDATEORGANIZATIONS,
				NotificationNames.UPDATEORGEMAILDOMAINS,
				NotificationNames.UPDATEADMINORGANIZATIONSVIEW
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case NotificationNames.ADMINORGANIZATIONUSERSVIEW:
					var body:Array = notification.getBody() as Array;
					organizations.populateUsers(body[0], body[1]);
					break;
				
				case NotificationNames.SETSPACE:
					if (notification.getBody() == Places.ORGANIZATIONS)
						populate();
					break;
					
				// Happens when we save an org, and indicates that we should just refresh the view
				case NotificationNames.UPDATEORGANIZATIONS:
				case NotificationNames.UPDATEORGEMAILDOMAINS:
					populate();
					break;
					
				case NotificationNames.UPDATEADMINORGANIZATIONSVIEW:
					organizations.populate(notification.getBody() as Array);
					break;
			}
		}
		
		protected function onCreationComplete(event:Event):void
		{
			displayObject.removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			populate();
		}
		
		protected function populate():void
		{
			adminOrganizationsViewProxy.adminOrganizationsView();
		}
		
		protected function onRefresh(event:ViewEvent):void
		{
			primaryProxy.clear();
			populate();
		}
		
		protected function onSubmit(event:ViewEvent):void
		{
			adminOrganizationsViewProxy.save(event.body);
		}
		
		protected function onFetch(event:ViewEvent):void
		{
			adminOrganizationsViewProxy.adminOrganizationUsersView(event.body as Number);
		}
		
	}
}