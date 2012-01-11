package net.poweru.presenters
{
	import net.poweru.Places;
	import net.poweru.proxies.CredentialTypeProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	
	public class EditCredentialTypeMediator extends BaseEditDialogMediator implements IMediator
	{
		public static const NAME:String = 'EditCredentialTypeMediator';
		
		public function EditCredentialTypeMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, CredentialTypeProxy, Places.EDITCREDENTIALTYPE);
		}
	}
}