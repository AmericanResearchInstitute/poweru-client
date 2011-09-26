package net.poweru.presenters
{
	import flash.events.Event;
	
	import mx.events.FlexEvent;
	
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.components.interfaces.IGroups;
	import net.poweru.events.ViewEvent;
	import net.poweru.proxies.GroupProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;

	public class GroupsMediator extends BaseMediator implements IMediator
	{
		public static const NAME:String = 'GroupsMediator';
		
		public function GroupsMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, GroupProxy);
		}
		
		protected function get groups():IGroups
		{
			return viewComponent as IGroups;
		}
		
		protected function get groupProxy():GroupProxy
		{
			return primaryProxy as GroupProxy;
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
				NotificationNames.UPDATEGROUPS,
				NotificationNames.UPDATEVODADMINGROUPSVIEW,
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case NotificationNames.SETSPACE:
					if (notification.getBody() == Places.GROUPS)
						populate();
					break;
					
				// Happens when we save a group, and indicates that we should just refresh the view
				case NotificationNames.UPDATEGROUPS:
					populate();
					break;
					
				case NotificationNames.UPDATEVODADMINGROUPSVIEW:
					groups.populate(notification.getBody() as Array);
					break;
			}
		}
		
		override protected function populate():void
		{	
			groupProxy.vodAdminGroupsView();
		}
		
	}
}