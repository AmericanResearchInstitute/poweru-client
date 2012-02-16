package net.poweru.presenters
{
	import org.puremvc.as3.interfaces.IMediator;
	
	public class AdminMediator extends BasePlaceContainerMediator implements IMediator
	{
		public static const NAME:String = 'AdminMediator';
		
		public function AdminMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
		}
	}
}