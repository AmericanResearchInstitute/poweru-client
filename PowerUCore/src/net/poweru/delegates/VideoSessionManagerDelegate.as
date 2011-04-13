package net.poweru.delegates
{
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;

	public class VideoSessionManagerDelegate extends BaseDelegate
	{
		public function VideoSessionManagerDelegate(responder:IResponder)
		{
			super(responder, 'VideoSessionManager', []);
		}
		
		// tells the back end that the user started watching a video
		public function registerVideoView(authToken:String, videoId:Number):void
		{
			// TODO actually call a remote method when one gets implemented
			trace('calling remote registerVideoView');
			var token:AsyncToken = remoteObject.getOperation('register_video_view').send(authToken, videoId);
			token.addResponder(responder);
		}
		
		public function watcherReport(authToken:String, videos:Array, startDate:Date=null, endDate:Date=null):void
		{
			var token:AsyncToken = remoteObject.getOperation('watcher_report').send(authToken, videos, mangleDate(startDate), mangleDate(endDate));
			token.addResponder(responder);
		}
		
		public function viewingActivityReport(authToken:String, users:Array, startDate:Date=null, endDate:Date=null):void
		{
			var token:AsyncToken = remoteObject.getOperation('viewing_activity_report').send(authToken, users, mangleDate(startDate), mangleDate(endDate));
			token.addResponder(responder);
		}
	}
}