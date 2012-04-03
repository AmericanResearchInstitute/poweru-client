package net.poweru.presenters
{
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.proxies.CredentialTypeProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	
	public class ChooseCredentialTypeMediator extends BaseSimpleChooserMediator implements IMediator
	{
		public static const NAME:String = 'ChooseCredentialMediator';
		
		public function ChooseCredentialTypeMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, Places.CHOOSECREDENTIALTYPE, NotificationNames.UPDATECREDENTIALTYPES, CredentialTypeProxy);
		}
	}
}