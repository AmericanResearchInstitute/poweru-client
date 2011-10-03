package net.poweru.components.interfaces
{
	public interface IBulkEnrollInEvent extends ICreateDialog
	{
		function populate(event:Object, sessions:Array, users:Array):void;
	}
}