package net.poweru.components.interfaces
{
	public interface ICreateDialog
	{
		// clear all controls
		function clear():void;
		
		// Returns the data that this dialog collects from the user
		function getData():Object;
		
		/*  Called when a "Chooser" dialog is used to make a selection,
			such as when choosing an organization for an event. */
		function receiveChoice(choice:Object, chooserName:String):void;
		
		/*  Called to set the choices that are available, usually for
			a ComboBox type control. */
		function setChoices(choices:Object):void;
		
	}
}