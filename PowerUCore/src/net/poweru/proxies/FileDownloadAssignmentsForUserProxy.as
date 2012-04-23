package net.poweru.proxies
{
	import mx.controls.Alert;
	import mx.rpc.events.ResultEvent;
	
	import net.poweru.NotificationNames;
	import net.poweru.delegates.AssignmentManagerDelegate;
	import net.poweru.delegates.FileDownloadManagerDelegate;
	import net.poweru.utils.PowerUResponder;
	
	import org.puremvc.as3.interfaces.IProxy;
	
	public class FileDownloadAssignmentsForUserProxy extends BaseProxy implements IProxy
	{
		public static const NAME:String = 'FileDownloadAssignmentsForUserProxy';
		
		public function FileDownloadAssignmentsForUserProxy()
		{
			super(NAME, AssignmentManagerDelegate, NotificationNames.UPDATEFILEDOWNLOADASSIGNMENTSFORUSER, []);
			init();
		}
		
		private function init():void
		{
			getFilteredMethodName = 'file_download_view';
			dateTimeFields = ['due_date'];
		}
		
		public function getDownloadURLForAssignment(assignmentID:Number):void
		{
			new FileDownloadManagerDelegate(new PowerUResponder(onGetDownloadURLForAssignmentSuccess, onGetDownloadURLForAssignmentFailure, onFault)).getDownloadURLForAssignment(loginProxy.authToken, assignmentID);
		}
		
		
		// Event Handlers
		
		protected function onGetDownloadURLForAssignmentSuccess(event:ResultEvent):void
		{
			sendNotification(NotificationNames.FILEDOWNLOADURLRECEIVED, event.result['value']);
		}
		
		protected function onGetDownloadURLForAssignmentFailure(event:ResultEvent):void
		{
			Alert.show('Error retrieving File Download URL');
		}
	}
}