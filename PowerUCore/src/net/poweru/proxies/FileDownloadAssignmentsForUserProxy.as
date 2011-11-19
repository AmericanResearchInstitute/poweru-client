package net.poweru.proxies
{
	import net.poweru.NotificationNames;
	import net.poweru.delegates.AssignmentManagerDelegate;
	
	import org.puremvc.as3.interfaces.IProxy;
	
	public class FileDownloadAssignmentsForUserProxy extends BaseProxy implements IProxy
	{
		public static const NAME:String = 'FileDownloadAssignmentsForUserProxy';
		
		public function FileDownloadAssignmentsForUserProxy()
		{
			super(NAME, AssignmentManagerDelegate, NotificationNames.UPDATEFILEDOWNLOADASSIGNMENTSFORUSER, []);
			getFilteredMethodName = 'file_download_assignments_for_user';
		}
	}
}