package net.poweru.proxies
{
	import com.adobe.utils.DateUtil;
	import net.poweru.NotificationNames;
	import net.poweru.delegates.VideoSessionManagerDelegate;
	import net.poweru.utils.PowerUResponder;
	
	import mx.rpc.events.ResultEvent;
	
	import org.puremvc.as3.interfaces.IProxy;

	public class VideoSessionProxy extends BaseProxy implements IProxy
	{
		public static const NAME:String = 'VideoSessionProxy';
		
		public function VideoSessionProxy()
		{
			super(NAME, VideoSessionManagerDelegate, NotificationNames.UPDATEVIDEOSESSIONS);
		}
		
		// tells the back end that the user started watching a video
		public function registerVideoView(videoId:Number):void
		{
			new VideoSessionManagerDelegate(new PowerUResponder(onRegisterVideoViewSuccess, onRegisterVideoViewError, onFault)).registerVideoView(loginProxy.authToken, videoId);
		}
		
		public function watcherReport(videos:Array, startDate:Date=null, endDate:Date=null):void
		{
			new VideoSessionManagerDelegate(new PowerUResponder(onWatcherReportSuccess, onWatcherReportError, onFault)).watcherReport(loginProxy.authToken, videos, startDate, endDate);
		}
		
		public function viewingActivityReport(users:Array, startDate:Date=null, endDate:Date=null):void
		{
			new VideoSessionManagerDelegate(new PowerUResponder(onViewingReportSuccess, onViewingReportError, onFault)).viewingActivityReport(loginProxy.authToken, users, startDate, endDate);
		}
		
		
		// Response Handlers
		
		protected function onRegisterVideoViewSuccess(event:ResultEvent):void
		{
			trace('register video view success');
		}
		
		protected function onRegisterVideoViewError(event:ResultEvent):void
		{
			trace('register video view error');
		}
		
		protected function onWatcherReportSuccess(event:ResultEvent):void
		{
			var data:Array = event.result.value as Array;
			for each (var item:Object in data)
			{
				item['date_started'] = DateUtil.parseW3CDTF(item['date_started']);
			}
			sendNotification(NotificationNames.VIDEOWATCHERREPORT, data);
		}
		
		protected function onWatcherReportError(event:ResultEvent):void
		{
			trace('video watcher report error');
		}
		
		protected function onViewingReportSuccess(event:ResultEvent):void
		{
			var data:Array = event.result.value as Array;
			for each (var item:Object in data)
			{
				item['date_started'] = DateUtil.parseW3CDTF(item['date_started']);
			}
			sendNotification(NotificationNames.VIEWINGACTIVITYREPORT, data);
		}
		
		protected function onViewingReportError(event:ResultEvent):void
		{
			trace('viewing activity report error');
		}
		
	}
}