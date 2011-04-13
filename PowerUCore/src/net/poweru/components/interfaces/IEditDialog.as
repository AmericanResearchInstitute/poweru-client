package net.poweru.components.interfaces
{
	public interface IEditDialog
	{
		function clear():void;
		function getData():Object;
		function populate(data:Object, ...args):void;
		function setChoices(choices:Object):void;
		function setState(state:String):void;
	}
}