package net.poweru.proxies
{
	import net.poweru.NotificationNames;
	import net.poweru.delegates.AchievementManagerDelegate;
	
	import org.puremvc.as3.interfaces.IProxy;
	
	public class AchievementProxy extends BaseProxy implements IProxy
	{
		public static const NAME:String = 'AchievementProxy';
		public static const FIELDS:Array = ['name', 'description'];
		
		public function AchievementProxy()
		{
			super(NAME, AchievementManagerDelegate, NotificationNames.UPDATEACHIEVEMENTS, FIELDS, 'Achievement', []);
			createArgNamesInOrder = ['name', 'description', 'component_achievements'];
		}
	}
}