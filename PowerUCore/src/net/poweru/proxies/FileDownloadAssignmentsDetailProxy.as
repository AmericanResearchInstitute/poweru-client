package net.poweru.proxies
{
	import net.poweru.NotificationNames;
	import net.poweru.delegates.AssignmentManagerDelegate;
	
	import org.puremvc.as3.interfaces.IProxy;
	
	public class FileDownloadAssignmentsDetailProxy extends BaseProxy implements IProxy
	{
		public static const NAME:String = 'FileDownloadAssignmentsDetailProxy';
		
		public function FileDownloadAssignmentsDetailProxy()
		{
			super(NAME, AssignmentManagerDelegate, NotificationNames.UPDATEFILEDOWNLOADASSIGNMENTSDETAIL, [], 'Assignment', []);
			init();
		}
		
		private function init():void
		{
			getFilteredMethodName = 'detailed_file_download_view';
		}
	}
}