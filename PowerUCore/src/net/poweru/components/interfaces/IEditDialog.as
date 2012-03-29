package net.poweru.components.interfaces
{
	import net.poweru.model.ChooserResult;

	public interface IEditDialog extends IClearableComponent
	{
		// Returns the data that this dialog collects from the user
		function getData():Object;
		
		// supplies data to the dialog
		function populate(data:Object, ...args):void;
		
		/*  Called when a "Chooser" dialog is used to make a selection,
		such as when choosing an organization for an event. */
		function receiveChoice(choice:ChooserResult, chooserName:String):void;
		
		/*  Called to set the choices that are available, usually for
		a ComboBox type control. */
		function setChoices(choices:Object):void;
		
		function setState(state:String):void;
	}
}