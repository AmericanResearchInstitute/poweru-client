package net.poweru.presenters
{
	import net.poweru.proxies.AchievementProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	
	public class CreateAchievementMediator extends BaseCreateDialogMediator implements IMediator
	{
		public static const NAME:String = 'CreateAchievementMediator';
		
		public function CreateAchievementMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, AchievementProxy);
		}
	}
}