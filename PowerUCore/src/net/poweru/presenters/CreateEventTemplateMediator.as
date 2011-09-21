package net.poweru.presenters
{
	import net.poweru.proxies.EventTemplateProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	
	public class CreateEventTemplateMediator extends BaseCreateDialogMediator implements IMediator
	{
		public static const NAME:String = 'CreateEventTemplateMediator';
		
		public function CreateEventTemplateMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, EventTemplateProxy);
		}
	}
}