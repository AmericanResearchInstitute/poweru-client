package net.poweru.presenters
{
	import net.poweru.proxies.OrganizationProxy;
	
	import org.puremvc.as3.interfaces.IMediator;

	public class CreateOrganizationMediator extends BaseCreateDialogMediator implements IMediator
	{
		public static const NAME:String = 'CreateOrganizationManager';
		
		public function CreateOrganizationMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent, OrganizationProxy);
		}
		
	}
}