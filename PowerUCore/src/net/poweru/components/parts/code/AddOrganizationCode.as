package net.poweru.components.parts.code
{
	import mx.containers.HBox;
	import mx.controls.Button;
	
	import net.poweru.Places;
	import net.poweru.model.ChooserResult;
	import net.poweru.utils.ChooserRequestTracker;

	public class AddOrganizationCode extends HBox
	{
		public var confirm:Button;
		protected var chooserRequestTracker:ChooserRequestTracker;
		[Bindable]
		protected var chosenOrganization:Object;
		[Bindable]
		protected var chosenOrgRole:Object;
		
		public function AddOrganizationCode()
		{
			super();
			chooserRequestTracker = new ChooserRequestTracker();
		}
		
		public function get selectedOrganization():Object
		{
			return chosenOrganization;
		}
		
		public function get selectedOrgRole():Object
		{
			return chosenOrgRole;
		}
		
		public function receiveChoice(choice:ChooserResult, chooserName:String):void
		{
			if (chooserRequestTracker.doIWantThis(chooserName, choice.requestID))
			{
				switch (chooserName)
				{
					case Places.CHOOSEORGANIZATION:
						chosenOrganization = choice.value;
						break;
					
					case Places.CHOOSEORGROLE:
						chosenOrgRole = choice.value;
						break;
				}
			}
				
		}
		
		override public function set currentState(value:String):void
		{
			super.currentState = value;
			if (value == 'adding')
			{
				chosenOrganization = null;
				chosenOrgRole = null;
			}
		}
	}
}