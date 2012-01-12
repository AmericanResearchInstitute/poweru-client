package net.poweru.presenters
{
	import net.poweru.Places;
	import net.poweru.proxies.TaskBundleProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	
	public class EditTaskBundleMediator extends BaseEditDialogMediator implements IMediator
	{
		public static const NAME:String = 'EditTaskBundleMediator';
		
		public function EditTaskBundleMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, TaskBundleProxy, Places.EDITTASKBUNDLE);
		}
	}
}