package net.poweru.components.interfaces
{
	public interface IOrganizations
	{
		function populate(data:Array):void;
		function clear():void;
		function populateUsers(org:Number, data:Array):void;
	}
}