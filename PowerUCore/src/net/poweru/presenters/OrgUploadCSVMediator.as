package net.poweru.presenters
{
	import net.poweru.proxies.OrganizationProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	
	public class OrgUploadCSVMediator extends BaseUploadCSVMediator implements IMediator
	{
		public static const NAME:String = 'OrgUploadCSVMediator';
		
		public function OrgUploadCSVMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, OrganizationProxy, 'organization', 'Organization');
		}
	}
}