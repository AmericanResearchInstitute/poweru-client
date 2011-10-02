package net.poweru.presenters
{
	import mx.events.FlexEvent;
	
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.components.interfaces.ISessionUserRoles;
	import net.poweru.events.ViewEvent;
	import net.poweru.proxies.SessionUserRoleProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class SessionUserRolesMediator extends BaseMediator implements IMediator
	{
		public static const NAME:String = 'SessionUserRolesMediator';
		
		public function SessionUserRolesMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, SessionUserRoleProxy);
		}
		
		protected function get sessionUserRoles():ISessionUserRoles
		{
			return viewComponent as ISessionUserRoles;
		}
		
		override protected function addEventListeners():void
		{
			displayObject.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			displayObject.addEventListener(ViewEvent.REFRESH, onRefresh);
			displayObject.addEventListener(ViewEvent.SHOWDIALOG, onShowDialog);
		}
		
		override protected function removeEventListeners():void
		{
			displayObject.removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);	
			displayObject.removeEventListener(ViewEvent.REFRESH, onRefresh);
			displayObject.removeEventListener(ViewEvent.SHOWDIALOG, onShowDialog);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				NotificationNames.SETSPACE,
				NotificationNames.UPDATESESSIONUSERROLES,
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case NotificationNames.SETSPACE:
					if (notification.getBody() == Places.SESSIONUSERROLES)
						populate();
					break;
				
				// Happens when we save a group, and indicates that we should just refresh the view
				case NotificationNames.UPDATESESSIONUSERROLES:
					sessionUserRoles.populate(primaryProxy.dataSet.toArray());
					break;
			}
		}
		
		override protected function populate():void
		{	
			primaryProxy.getAll();
		}
	}
}