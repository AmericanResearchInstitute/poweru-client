package net.poweru.components.interfaces
{
	import mx.collections.ArrayCollection;
	
	public interface IUsers
	{
		function clear():void;
		function populate(users:Array, organizations:Array, orgRoles:Array, groups:Array, choices:Object):void;
	}
}