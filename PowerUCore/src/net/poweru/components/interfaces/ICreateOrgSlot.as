package net.poweru.components.interfaces
{
	public interface ICreateOrgSlot extends ICreateDialog
	{
		function populate(roles:Array, organization:Object):void;
	}
}