package net.poweru.presenters
{
	import net.poweru.presenters.BaseCreateDialogMediator;
	import net.poweru.proxies.UserProxy;
	
	import org.puremvc.as3.interfaces.IMediator;

	public class CreateUserMediator extends BaseCreateDialogMediator implements IMediator
	{
		public static const NAME:String = 'CreateUserMediator';
		
		public function CreateUserMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent, UserProxy);
		}
		
	}
}