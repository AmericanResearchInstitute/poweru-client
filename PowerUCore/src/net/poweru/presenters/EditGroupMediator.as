package net.poweru.presenters
{
	import net.poweru.Places;
	import net.poweru.proxies.GroupProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	
	public class EditGroupMediator extends BaseEditDialogMediator implements IMediator
	{
		public static const NAME:String = 'EditGroupMediator';
		
		public function EditGroupMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, GroupProxy, Places.EDITGROUP);
		}
	}
}