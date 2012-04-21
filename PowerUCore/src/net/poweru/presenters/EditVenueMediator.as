package net.poweru.presenters
{
	import net.poweru.Places;
	import net.poweru.proxies.VenueProxy;
	import net.poweru.utils.InputCollector;
	
	import org.puremvc.as3.interfaces.IMediator;
	
	public class EditVenueMediator extends BaseEditDialogMediator implements IMediator
	{
		public static const NAME:String = 'EditVenueMediator';
		
		protected var inputCollector:InputCollector;
		
		public function EditVenueMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, VenueProxy, Places.EDITVENUE);
		}
	}
}