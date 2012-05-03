package net.poweru.components.interfaces
{
	public interface ICreateSession extends ICreateDialog
	{
		/*	This dialog will need some data from its event, and that will
			be passed in through this method. */
		function populateEventData(data:Object):void;
		function get creationIsComplete():Boolean;
	}
}