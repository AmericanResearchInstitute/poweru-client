package net.poweru.components.interfaces
{
	public interface IVenues
	{
		function populate(data:Array):void;
		function clear():void;
		function setBlackoutPeriods(data:Array):void;
		function setRooms(data:Array):void;
	}
}