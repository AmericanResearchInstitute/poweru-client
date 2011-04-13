package net.poweru.components.code
{
	import mx.containers.HBox;
	import mx.containers.VBox;
	import mx.controls.Alert;
	import mx.core.Container;
	
	import net.poweru.components.interfaces.IMain;

	public class MainCode extends VBox implements IMain
	{
		[Bindable]
		protected var buttonBoxVisible:Boolean = false;
		public var mainSpace:HBox;
		
		public function setButtonBoxVisibility(visible:Boolean):void
		{
			buttonBoxVisible = visible;
		}
		
		public function getSpace():Container
		{
			return mainSpace;
		}
		
		public function changeState(state:String):void
		{
			currentState = state;
		}
		
		public function passwordChangeSuccess():void
		{
			Alert.show('Password change succeeded.');
		}
	}
}