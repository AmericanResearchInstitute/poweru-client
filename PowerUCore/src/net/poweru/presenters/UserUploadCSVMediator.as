package net.poweru.presenters
{
	import net.poweru.proxies.UserProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	
	public class UserUploadCSVMediator extends BaseUploadCSVMediator implements IMediator
	{
		public static const NAME:String = 'UserUploadCSVMediator';
		
		public function UserUploadCSVMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, UserProxy, 'user', 'User');
		}
	}
}