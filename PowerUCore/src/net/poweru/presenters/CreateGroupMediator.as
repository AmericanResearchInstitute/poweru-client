package net.poweru.presenters
{
	import net.poweru.presenters.BaseCreateDialogMediator;
	import net.poweru.proxies.GroupProxy;
	
	import org.puremvc.as3.interfaces.IMediator;

	public class CreateGroupMediator extends BaseCreateDialogMediator implements IMediator
	{
		public static const NAME:String = 'CreateGroupMediator';
		
		public function CreateGroupMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent, GroupProxy);
		}
		
	}
}