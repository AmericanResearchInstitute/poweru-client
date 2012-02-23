package net.poweru.components.interfaces
{
	public interface ICreateTaskFee extends ICreateDialog
	{
		// The create dialog needs to know what task this goes with
		function set taskID(data:Number):void;
	}
}