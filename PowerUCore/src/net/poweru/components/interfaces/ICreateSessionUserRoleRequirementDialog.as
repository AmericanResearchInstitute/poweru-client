package net.poweru.components.interfaces
{
	public interface ICreateSessionUserRoleRequirementDialog extends ICreateDialog
	{
		// array of SessionUserRole objects
		function populate(session:Object, roles:Array):void;
	}
}