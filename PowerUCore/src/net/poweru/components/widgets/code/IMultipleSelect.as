package net.poweru.components.widgets.code
{
	import mx.core.IUIComponent;
	import mx.validators.NumberValidator;
	
	public interface IMultipleSelect extends IUIComponent
	{
		function populate(choices:Array, selectedItems:Array):void;
		function get selectedItems():Array;
		function get validator():NumberValidator;
	}
}