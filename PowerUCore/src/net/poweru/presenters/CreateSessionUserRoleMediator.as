package net.poweru.presenters
{
	import net.poweru.proxies.SessionUserRoleProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	
	public class CreateSessionUserRoleMediator extends BaseCreateDialogMediator implements IMediator
	{
		public static const NAME:String = 'CreateSessionUserRoleMediator';
		
		public function CreateSessionUserRoleMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, SessionUserRoleProxy);
		}
	}
}