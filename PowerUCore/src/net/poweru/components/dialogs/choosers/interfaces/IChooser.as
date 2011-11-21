package net.poweru.components.dialogs.choosers.interfaces
{
	public interface IChooser
	{
		function populate(data:Array, ...args):void;
		function clear():void;
	}
}