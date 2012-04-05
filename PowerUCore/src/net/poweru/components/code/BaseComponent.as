package net.poweru.components.code
{
	import mx.containers.HBox;
	
	public class BaseComponent extends HBox
	{
		public function BaseComponent()
		{
			super();
		}
		
		public function setState(state:String):void
		{
			if (state != currentState)
			{
				try
				{
					currentState = state;
				}
				catch (err:ArgumentError)
				{
					; // If the state isn't defined, no sweat. Stick with the default.
				}
			}
		}
	}
}