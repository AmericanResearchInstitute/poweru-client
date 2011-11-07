package net.poweru.proxies
{
	import flash.net.FileReference;
	
	import net.poweru.NotificationNames;
	import net.poweru.delegates.FileDownloadManagerDelegate;
	
	import org.puremvc.as3.interfaces.IProxy;
	
	public class FileDownloadProxy extends BaseProxy implements IProxy
	{
		public static const NAME:String = 'FileDownloadProxy';
		public static const FIELDS:Array = ['name', 'title', 'description'];
		
		public function FileDownloadProxy()
		{
			super(NAME, FileDownloadManagerDelegate, NotificationNames.UPDATEFILEDOWNLOADS, FIELDS);
			createArgNamesInOrder = ['name', 'title'];
			createOptionalArgNames = ['description'];
		}
		
		public function uploadFileDownload(file:FileReference, data:Object):void
		{
			uploadFile(file, data, browserServicesProxy.fileDownloadUploadURL, 'file_data');
		}
	}
}