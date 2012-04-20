package net.poweru.proxies
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.managers.BrowserManager;
	import mx.managers.IBrowserManager;
	import mx.utils.UIDUtil;
	
	import net.poweru.NotificationNames;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class BrowserServicesProxy extends Proxy implements IProxy
	{
		public static const NAME:String = 'BrowserServicesProxy';
		
		protected var browserManager:IBrowserManager;
		protected var _canUseCookies:Boolean = false;
		protected var _backendURL:String;
		
		public function BrowserServicesProxy()
		{
			super(NAME, null);
			init();	
		}
		
		protected function init():void
		{
			browserManager = BrowserManager.getInstance();
			browserManager.init('', '');
			
			// Try to set and get a cookie, so we know if this is possible
			if (ExternalInterface.available)
			{
				var value:String = UIDUtil.createUID();
				setCookie('delme', value);
				if (getCookie('delme') == value)
				{
					_canUseCookies = true;
					deleteCookie('delme');
				}
			}
		}
		
		public function get canUseCookies():Boolean
		{
			return _canUseCookies;
		}
		
		public function get baseURL():String
		{
			return browserManager.base;
		}
		
		public function get rpcURL():String
		{
			return backendURL + 'amf/';
		}
		
		public function get videoUploadURL():String
		{
			return backendURL + 'vod_aws/upload_video';
		}
		
		public function get csvUploadURL():String
		{
			return backendURL + 'upload_csv';
		}
		
		public function get videoThumbnailUploadURL():String
		{
			return backendURL + 'vod_aws/upload_video_photo';
		}
		
		public function get fileDownloadUploadURL():String
		{
			return backendURL + 'file_tasks/upload_file_for_download/';
		}
		
		public function get usingSSL():Boolean
		{
			return (_backendURL.indexOf('https') == 0);
		}
		
		public function determineBackendURL():void
		{
			var backendPointerURL:String = stripFileFromURL(baseURL).concat('backend_url.txt');
			var urlRequest:URLRequest = new URLRequest(backendPointerURL);
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, onLoadBackendPointerComplete);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onLoadBackendPointerError);
			urlLoader.load(urlRequest);
		}
		
		protected function onLoadBackendPointerComplete(event:Event):void
		{
			_backendURL = event.target.data;
			sendNotification(NotificationNames.BACKENDREADY, backendURL);
		}
		
		protected function onLoadBackendPointerError(event:IOErrorEvent):void
		{
			 _backendURL = stripFileFromURL(baseURL) + 'svc/';
			 sendNotification(NotificationNames.BACKENDREADY, backendURL);
		}
		
		// if a url ends in a file name like index.html, strip it, and make
		// sure there is a trailing /
		protected function stripFileFromURL(url:String):String
		{
			var ret:String;
			
			// use location of final / and . to determine if the baseURL
			// ends in a file name like index.html, and if so, strip it
			if (url.lastIndexOf('/') == url.length - 1)
					ret = url;
			else
			{
				var lastSlashIndex:int = url.lastIndexOf('/');
				var lastDotIndex:int = url.lastIndexOf('.');
				
				if (lastSlashIndex >= lastDotIndex)
					ret = url;
				else
					ret = url.slice(0, lastSlashIndex + 1);
			}
			
			// make sure a trailing / is present
			if (ret.lastIndexOf('/') != ret.length - 1)
				ret = ret.concat('/');
			
			return ret;
		}
		
		public function get backendURL():String
		{
			return _backendURL;
		}
		
		public function setCookie(key:String, value:String):void
		{
			if (ExternalInterface.available)
				ExternalInterface.call('jaaulde.utils.cookies.set', key, value);
		}
		
		public function getCookie(key:String):String
		{
			var ret:String = '';
			if (ExternalInterface.available)
				ret = ExternalInterface.call('jaaulde.utils.cookies.get', key);
			return ret;
		}
		
		public function deleteCookie(key:String):void
		{
			if (ExternalInterface.available)
				ExternalInterface.call('jaaulde.utils.cookies.del', key);
		}
		
	}
}