package net.poweru.presenters
{
	import net.poweru.Places;
	import net.poweru.proxies.AchievementProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	
	public class EditAchievementMediator extends BaseEditDialogMediator implements IMediator
	{
		public static const NAME:String = 'EditAchievementMediator';
		
		public function EditAchievementMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, AchievementProxy, Places.EDITACHIEVEMENT);
		}
	}
}