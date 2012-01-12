package net.poweru.presenters
{
	import net.poweru.proxies.TaskBundleProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	
	public class CreateTaskBundleMediator extends BaseCreateDialogMediator implements IMediator
	{
		public static const NAME:String = 'CreateTaskBundleMediator';
		
		public function CreateTaskBundleMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, TaskBundleProxy);
		}
	}
}