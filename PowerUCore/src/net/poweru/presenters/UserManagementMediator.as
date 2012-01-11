package net.poweru.presenters
{
	import org.puremvc.as3.interfaces.IMediator;
	
	public class UserManagementMediator extends BasePlaceContainerMediator implements IMediator
	{
		public static const NAME:String = 'UserManagementMediator';
		
		public function UserManagementMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
		}
	}
}