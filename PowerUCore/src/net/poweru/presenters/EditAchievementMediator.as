package net.poweru.presenters
{
	import flash.events.Event;
	
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.proxies.AchievementProxy;
	import net.poweru.utils.InputCollector;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class EditAchievementMediator extends BaseEditDialogMediator implements IMediator
	{
		public static const NAME:String = 'EditAchievementMediator';
		
		public function EditAchievementMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, AchievementProxy, Places.EDITACHIEVEMENT);
		}
	}
}