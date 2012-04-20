package net.poweru.components.widgets.code
{
	import mx.containers.HBox;
	import mx.controls.ComboBox;
	import mx.controls.TextInput;
	import mx.validators.NumberValidator;
	
	public class DaysInputCode extends HBox
	{
		protected static const UNITS:Array = [
			{'name' : 'days', 'multiplier' : 1},
			{'name' : 'weeks', 'multiplier' : 7},
			{'name' : 'years', 'multiplier' : 365}
		];
		
		[Bindable]
		public var numInput:TextInput;
		public var unitsInput:ComboBox;
		[Bindable]
		public var required:Boolean = false;
		public var validator:NumberValidator;
		
		public function DaysInputCode()
		{
			super();
		}
		
		public function set days(value:Object):void
		{
			unitsInput.selectedIndex = 0;
			if (value == null)
				numInput.text = '';
			else
				numInput.text = String(Number(value));
		}
		
		public function get days():Object
		{
			var multiplier:Number = unitsInput.selectedItem.multiplier;
			
			return (numInput.text == null || numInput.text == '') ? null : Number(numInput.text) * multiplier;
		}
		
		public function clear():void
		{
			days = null;
		}
	}
}