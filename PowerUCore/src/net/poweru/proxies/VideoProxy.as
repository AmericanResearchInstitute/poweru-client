package net.poweru.proxies
{
	import com.adobe.utils.DateUtil;
	import net.poweru.ApplicationFacade;
	import net.poweru.NotificationNames;
	import net.poweru.delegates.VideoManagerDelegate;
	import net.poweru.model.DataSet;
	import net.poweru.utils.PowerUResponder;
	
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	import mx.rpc.events.ResultEvent;
	
	import org.puremvc.as3.interfaces.IProxy;
	
	public class VideoProxy extends BaseProxy implements IProxy
	{
		public static var NAME:String = 'VideoProxy';
		
		protected var browserServicesProxy:BrowserServicesProxy; 
		protected var videoCateogoryProxy:VideoCategoryProxy;
		
		public function VideoProxy()
		{
			super(NAME, VideoManagerDelegate, NotificationNames.UPDATEVIDEOS);
			browserServicesProxy = (facade as ApplicationFacade).retrieveOrRegisterProxy(BrowserServicesProxy) as BrowserServicesProxy;
			videoCateogoryProxy = (facade as ApplicationFacade).retrieveOrRegisterProxy(VideoCategoryProxy) as VideoCategoryProxy;
		}
		
		public function adminVideosView():void
		{
			new VideoManagerDelegate(new PowerUResponder(onAdminVideosViewSuccess, onAdminVideosViewError, onFault)).adminVideosView(loginProxy.authToken);
		}
		
		public function userVideosView():void
		{
			new VideoManagerDelegate(new PowerUResponder(onUserVideosViewSuccess, onUserVideosViewError, onFault)).userVideosView(loginProxy.authToken);
		}

		public function uploadVideo(file:FileReference, data:Object):void
		{
			uploadFile(file, data, browserServicesProxy.videoUploadURL, 'video');
		}
		
		public function uploadThumbnail(bytes:ByteArray, data:Object):void
		{
			uploadByteArray(bytes, data, browserServicesProxy.videoThumbnailUploadURL, 'photo');
		}
		
		/*	We need to possibly update an attribute on the through table, which
			involves calling a separate delegate */
		override public function save(data:Object, oldItem:Object=null):void
		{
			var cachedItem:Object = oldItem ? oldItem : dataSet.findByPK(data['id']);
			
			var oldCategoryRelationships:DataSet = new DataSet(cachedItem['category_relationships']);
			
			for each (var categoryRelationship:Object in data['category_relationships'])
			{
				if (oldCategoryRelationships.findByPK(categoryRelationship['id']) != null)
					videoCateogoryProxy.save(categoryRelationship, oldCategoryRelationships.findByPK(categoryRelationship['id']));
			}
			
			super.save(data);
		}
		
		protected function onAdminVideosViewSuccess(event:ResultEvent):void
		{
			data = new DataSet(event.result.value);
			
			for each (var item:Object in data)
			{
				item['create_timestamp'] = DateUtil.parseW3CDTF(item['create_timestamp']);
			}
			
			sendNotification(NotificationNames.UPDATEADMINVIDEOSVIEW, event.result.value);
		}
		
		protected function onAdminVideosViewError(event:ResultEvent):void
		{
			trace('error: VideoManager.admin_videos_view');
		}
		
		protected function onUserVideosViewSuccess(event:ResultEvent):void
		{
			data = new DataSet(event.result.value);
			sendNotification(NotificationNames.UPDATEUSERVIDEOSVIEW, event.result.value);
		}
		
		protected function onUserVideosViewError(event:ResultEvent):void
		{
			trace('error: VideoManager.user_videos_view');	
		}
	}
}