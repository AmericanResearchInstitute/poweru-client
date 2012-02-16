package net.poweru.presenters
{
	import net.poweru.Places;
	import net.poweru.proxies.MessageTemplateProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	
	public class EditMessageTemplateMediator extends BaseEditDialogMediator implements IMediator
	{
		public static const NAME:String = 'EditMessageTemplateMediator';
		
		public function EditMessageTemplateMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, MessageTemplateProxy, Places.EDITMESSAGETEMPLATE);
		}
	}
}