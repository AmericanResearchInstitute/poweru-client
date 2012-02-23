package net.poweru.presenters
{
	import net.poweru.Places;
	import net.poweru.proxies.AssignmentProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	
	public class EditAssignmentMediator extends BaseEditDialogMediator implements IMediator
	{
		public static const NAME:String = 'EditAssignmentMediator';
		
		public function EditAssignmentMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, AssignmentProxy, Places.EDITASSIGNMENT);
		}
	}
}