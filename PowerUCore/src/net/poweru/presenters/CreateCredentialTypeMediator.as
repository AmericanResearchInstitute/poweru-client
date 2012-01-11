package net.poweru.presenters
{
	import net.poweru.proxies.CredentialTypeProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	
	public class CreateCredentialTypeMediator extends BaseCreateDialogMediator implements IMediator
	{
		public static const NAME:String = 'CreateCredentialTypeMediator';
		
		public function CreateCredentialTypeMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, CredentialTypeProxy);
		}
	}
}