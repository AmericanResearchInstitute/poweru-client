package net.poweru.proxies
{
	import net.poweru.NotificationNames;
	import net.poweru.delegates.RegionManagerDelegate;
	
	import org.puremvc.as3.interfaces.IProxy;
	
	public class RegionProxy extends BaseProxy implements IProxy
	{
		public static const NAME:String = 'RegionProxy';
		
		public function RegionProxy()
		{
			super(NAME, RegionManagerDelegate, NotificationNames.UPDATEREGIONS, [], 'Region');
		}
	}
}