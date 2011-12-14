package net.poweru.presenters
{
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.proxies.AchievementProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	
	public class ChooseAchievementMediator extends BaseSimpleChooserMediator implements IMediator
	{
		public static const NAME:String = 'ChooseAchievementMediator';
		
		public function ChooseAchievementMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, Places.CHOOSEACHIEVEMENT, NotificationNames.UPDATEACHIEVEMENTS, AchievementProxy);
		}
	}
}