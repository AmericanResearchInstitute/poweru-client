package net.poweru.presenters
{
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.proxies.TaskProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	
	public class ChooseTaskMediator extends BaseSimpleChooserMediator implements IMediator
	{
		public static const NAME:String = 'ChooseTaskMediator';
		
		public function ChooseTaskMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, Places.CHOOSETASK, NotificationNames.UPDATETASKS, TaskProxy);
		}
	}
}