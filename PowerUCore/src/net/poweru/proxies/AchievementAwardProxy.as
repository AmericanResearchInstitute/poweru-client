package net.poweru.proxies
{
	import net.poweru.NotificationNames;
	import net.poweru.delegates.AchievementAwardManagerDelegate;
	
	import org.puremvc.as3.interfaces.IProxy;
	
	public class AchievementAwardProxy extends BaseProxy implements IProxy
	{
		public static const NAME:String = 'AchievementAwardProxy';
		public static const FIELDS:Array = ['achievement', 'achievement_name', 'date'];
		
		public function AchievementAwardProxy()
		{
			super(NAME, AchievementAwardManagerDelegate, NotificationNames.UPDATEACHIEVEMENTAWARDS, FIELDS, 'AchievementAward');
			dateTimeFields = ['date'];
		}
	}
}