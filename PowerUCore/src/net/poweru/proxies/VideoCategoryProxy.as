package net.poweru.proxies
{
	import net.poweru.NotificationNames;
	import net.poweru.delegates.VideoCategoryManagerDelegate;
	
	import org.puremvc.as3.interfaces.IProxy;

	public class VideoCategoryProxy extends BaseProxy implements IProxy
	{
		public static const NAME:String = 'VideoCategoryProxy';
		public static const FIELDS:Array = [];
		
		public function VideoCategoryProxy()
		{
			super(NAME, VideoCategoryManagerDelegate, NotificationNames.UPDATEVIDEOCATEGORIES, FIELDS, 'VideoCategory', ['status']);
		}
		
	}
}