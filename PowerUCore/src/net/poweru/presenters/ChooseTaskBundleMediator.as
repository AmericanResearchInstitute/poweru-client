package net.poweru.presenters
{
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.proxies.TaskBundleProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	
	public class ChooseTaskBundleMediator extends BaseSimpleChooserMediator implements IMediator
	{
		public static const NAME:String = 'ChooseTaskBundleMediator';
		
		public function ChooseTaskBundleMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, Places.CHOOSETASKBUNDLE, NotificationNames.UPDATETASKBUNDLESS, TaskBundleProxy);
		}
	}
}