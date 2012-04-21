package net.poweru.presenters.student
{
	import mx.events.FlexEvent;
	
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.events.ViewEvent;
	import net.poweru.presenters.BaseMediator;
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
		
		protected function get fileDownloadAssignmentsForUserProxy():FileDownloadAssignmentsForUserProxy
		{
			return primaryProxy as FileDownloadAssignmentsForUserProxy;
		}
		
		override protected function addEventListeners():void
		{
			displayObject.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			displayObject.addEventListener(ViewEvent.REFRESH, onRefresh);
			displayObject.addEventListener(ViewEvent.SHOWDIALOG, onShowDialog);
			displayObject.addEventListener(ViewEvent.SUBMIT, onSubmit);
		}
		
		override protected function removeEventListeners():void
		{
			displayObject.removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);	
			displayObject.removeEventListener(ViewEvent.REFRESH, onRefresh);
			displayObject.removeEventListener(ViewEvent.SHOWDIALOG, onShowDialog);
			displayObject.removeEventListener(ViewEvent.SUBMIT, onSubmit);
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
					arrayPopulatedComponent.populate(primaryProxy.dataSet.toArray());
					break;
				
				super.handleNotification(notification);
			}
		}
		
		override protected function populate():void
		{
			primaryProxy.getAll();
		}
		
		protected function onSubmit(event:ViewEvent):void
		{
			fileDownloadAssignmentsForUserProxy.getDownloadURLForAssignment(event.body as Number);
		}
	}
}