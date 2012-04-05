package net.poweru.components.interfaces
{
	public interface IArrayPopulatedComponent extends IClearableComponent
	{
		function populate(data:Array):void;
		function setState(state:String):void;
	}
}