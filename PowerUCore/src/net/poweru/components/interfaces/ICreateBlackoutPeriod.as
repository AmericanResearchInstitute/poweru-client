package net.poweru.components.interfaces
{
	public interface ICreateBlackoutPeriod extends ICreateDialog
	{
		/*	This dialog will need some data from its event, and that will
		be passed in through this method. */
		function populateVenueData(data:Object):void;
	}
}