package net.poweru.presenters
{
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.proxies.GroupProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	
	public class ChooseGroupMediator extends BaseSimpleChooserMediator implements IMediator
	{
		public static const NAME:String = 'ChooseGroupMediator';
		
		public function ChooseGroupMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, Places.CHOOSEGROUP, NotificationNames.UPDATEGROUPS, GroupProxy);
		}
	}
}