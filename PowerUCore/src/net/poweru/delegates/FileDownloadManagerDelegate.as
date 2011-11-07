package net.poweru.delegates
{
	import mx.rpc.IResponder;
	
	public class FileDownloadManagerDelegate extends BaseDelegate
	{
		public function FileDownloadManagerDelegate(responder:IResponder)
		{
			super(responder, 'FileDownloadManager');
		}
	}
}