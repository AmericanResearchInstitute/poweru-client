package net.poweru.presenters
{
	import mx.controls.Alert;
	
	import net.poweru.Places;
	import net.poweru.proxies.LoginProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	
	public class ChooseLoginContextMediator extends BaseChooserMediator implements IMediator
	{
		public static const NAME:String = 'ChooseLoginContextMediator';
		
		public function ChooseLoginContextMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, Places.CHOOSELOGINCONTEXT, '', LoginProxy);
		}
		
		override protected function populate():void
		{
			super.populate();
			var data:Array = loginProxy.currentUser.owned_userorgroles as Array;
			if (data == null || data.length == 0)
				Alert.show('No organization affiliations to choose from.', 'Error');
			else
				chooser.populate(data);
		}
	}
}