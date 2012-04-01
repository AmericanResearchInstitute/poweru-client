package net.poweru.presenters
{
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.proxies.OrgRoleProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	
	public class ChooseOrgRoleMediator extends BaseSimpleChooserMediator implements IMediator
	{
		public static const NAME:String = 'ChooseOrgRoleMediator';
		
		public function ChooseOrgRoleMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, Places.CHOOSEORGROLE, NotificationNames.UPDATEORGROLES, OrgRoleProxy);
		}
	}
}