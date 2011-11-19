package net.poweru.presenters.student
{
	import mx.events.FlexEvent;
	
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.components.student.interfaces.IFileDownloadAssignments;
	import net.poweru.events.ViewEvent;
	import net.poweru.presenters.BaseMediator;
	import net.poweru.proxies.FileDownloadProxy;
	import net.poweru.proxies.FileDownloadAssignmentsForUserProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class FileDownloadAssignmentsMediator extends BaseMediator implements IMediator
	{
		public static const NAME:String = 'FielDownloadAssignmentsMediator';
		
		public function FileDownloadAssignmentsMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, FileDownloadAssignmentsForUserProxy);
		}
		
		protected function get assignments():IFileDownloadAssignments
		{
			return displayObject as IFileDownloadAssignments;
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
				NotificationNames.UPDATEFILEDOWNLOADASSIGNMENTSFORUSER,
				NotificationNames.LOGOUT
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case NotificationNames.SETSPACE:
					if (notification.getBody() == Places.FILEDOWNLOADASSIGNMENTS)
						populate();
					break;
				
				// Happens when we save an Event, and indicates that we should just refresh the view
				case NotificationNames.UPDATEFILEDOWNLOADASSIGNMENTSFORUSER:
					assignments.populate(primaryProxy.dataSet.toArray());
					break;
				
				case NotificationNames.LOGOUT:
					assignments.clear();
					break;
			}
		}
		
		override protected function populate():void
		{
			primaryProxy.getAll();
		}
	}
}