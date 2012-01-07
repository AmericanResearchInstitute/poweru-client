package net.poweru.delegates
{
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	
	public class FileDownloadManagerDelegate extends BaseDelegate
	{
		public function FileDownloadManagerDelegate(responder:IResponder)
		{
			super(responder, 'FileDownloadManager');
		}
	
		public function getDownloadURLForAssignment(authToken:String, assignmentID:Number):void
		{
			var token:AsyncToken = remoteObject.getOperation('get_download_url_for_assignment').send(authToken, assignmentID);
			token.addResponder(responder);
			token.assignmentID = assignmentID;
		}
	}
}