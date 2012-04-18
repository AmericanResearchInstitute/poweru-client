package net.poweru.presenters
{
	import net.poweru.Places;
	import net.poweru.proxies.CredentialProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	
	public class EditCredentialMediator extends BaseEditDialogMediator implements IMediator
	{
		public static const NAME:String = 'EditCredentialMediator';
		
		public function EditCredentialMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, CredentialProxy, Places.EDITCREDENTIAL);
		}
	}
}