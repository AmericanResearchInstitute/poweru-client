package net.poweru.presenters
{
	import org.puremvc.as3.interfaces.IMediator;
	
	public class CredentialManagementMediator extends BasePlaceContainerMediator implements IMediator
	{
		public static const NAME:String = 'CredentialManagementMediator';
		
		public function CredentialManagementMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
		}
	}
}