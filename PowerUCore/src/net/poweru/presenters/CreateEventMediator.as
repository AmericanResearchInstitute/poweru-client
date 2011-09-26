package net.poweru.presenters
{
	import net.poweru.NotificationNames;
	import net.poweru.proxies.EventProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class CreateEventMediator extends BaseCreateDialogMediator implements IMediator
	{
		public static const NAME:String = 'CreateEventMediator';
		
		public function CreateEventMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, EventProxy);
		}
	}
}