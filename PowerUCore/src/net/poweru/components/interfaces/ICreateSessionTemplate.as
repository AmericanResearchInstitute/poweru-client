package net.poweru.components.interfaces
{
	public interface ICreateSessionTemplate extends ICreateDialog
	{
		/*	This dialog will need some data from its event template, and that will
			be passed in through this method. */
		function populateEventTemplateData(data:Object):void;
	}
}