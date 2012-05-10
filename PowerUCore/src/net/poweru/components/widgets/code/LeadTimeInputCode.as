package net.poweru.components.widgets.code
{
	import mx.containers.HBox;
	import mx.controls.ComboBox;
	import mx.controls.TextInput;
	import mx.validators.NumberValidator;
	
	import net.poweru.model.DataSet;
	import net.poweru.utils.LabelFunctions;
	
	public class LeadTimeInputCode extends HBox
	{
		protected static const UNITS:DataSet = new DataSet([
			{'name' : 'seconds', 'multiplier' : 1},
			{'name' : 'minutes', 'multiplier' : 60},
			{'name' : 'hours', 'multiplier' : 60*60},
			{'name' : 'days', 'multiplier' : 60*60*24}
		]);
		
		[Bindable]
		public var numInput:TextInput;
		public var unitsInput:ComboBox;
		[Bindable]
		public var required:Boolean = false;
		public var validator:NumberValidator;
		
		public function LeadTimeInputCode()
		{
			super();
		}
		
		public function set seconds(value:Object):void
		{
			
			if (value == null)
			{
				numInput.text = '';
				unitsInput.selectedIndex = 2;
			}
			else
			{
				var formatInfo:Object = LabelFunctions.getLeadTimeFormatInfo(Number(value));
				numInput.text = String(formatInfo['value']);
				unitsInput.selectedItem = UNITS.findByKey('name', formatInfo['units']);
			}
		}
		
		public function get seconds():Object
		{
			var multiplier:Number = unitsInput.selectedItem.multiplier;
			
			return (numInput.text == null || numInput.text == '') ? null : Number(numInput.text) * multiplier;
		}
		
		public function clear():void
		{
			seconds = null;
		}
	}
}