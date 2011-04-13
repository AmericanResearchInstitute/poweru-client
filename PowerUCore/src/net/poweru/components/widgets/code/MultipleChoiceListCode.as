package net.poweru.components.widgets.code
{
	import mx.containers.Grid;
	import mx.containers.GridItem;
	import mx.containers.GridRow;
	import mx.containers.VBox;
	import mx.controls.Label;
	import mx.controls.RadioButton;
	import mx.controls.RadioButtonGroup;

	public class MultipleChoiceListCode extends VBox implements IMultipleChoiceList
	{
		[Bindable]
		public var labelField:String;
		public var grid:Grid;
		// name of boolean field which signifies that a row should be disabled
		public var disabledField:String = '';
		
		protected var _choices:Array;
		
		public function MultipleChoiceListCode()
		{
			super();
		}
		
		public function get choices():Array
		{
			return _choices;
		}
		
		public function populate(choices:Array, items:Array):void
		{	
			this._choices = choices;
			this.data = items;
			
			grid.removeAllChildren();
			
			var firstRow:GridRow = new GridRow();
			firstRow.addChild(new GridItem());
			
			for each (var choice1:String in choices)
			{
				var label:Label = new Label();
				label.text = choice1;
				var choiceItem:GridItem = new GridItem();
				choiceItem.addChild(label);
				firstRow.addChild(choiceItem);
			}
			
			grid.addChild(firstRow);
			
			// build each row
			for each (var item:Object in items)
			{
				var disabled:Boolean = (disabledField.length > 0 && item.hasOwnProperty(disabledField) && (item[disabledField] as Boolean == true));
				
				var gridRow:GridRow = new GridRow();
				gridRow.data = item;
				
				var categoryLabel:Label = new Label();
				categoryLabel.text = item[labelField];
				
				var gridItem:GridItem = new GridItem();
				gridItem.addChild(categoryLabel);
				gridRow.addChild(gridItem);
				
				var group:RadioButtonGroup = new RadioButtonGroup();
				
				for each (var choice2:String in choices)
				{
					var button:RadioButton = new RadioButton();
					button.group = group;
					button.enabled = !disabled;
					button.data = choice2;
					if (choice2 == item['status'])
						button.selected = true;
						
					var gItem:GridItem = new GridItem();
					gItem.addChild(button);
					gridRow.addChild(gItem);
				}
				
				grid.addChild(gridRow);
			}
		}
		
		// iterates through rows and records the button selections
		protected function updateData():void
		{
			for each (var row:GridRow in grid.getChildren())
			{
				var item:Object = row.data;
				if (item == null)
					continue;
				for each (var gItem:GridItem in row.getChildren())
					if (gItem.getChildren().length == 1)
					{
						var button:RadioButton = gItem.getChildAt(0) as RadioButton;
						if (button == null)
							continue;
						if (button.selected == true)
							item['status'] = button.data;
					}
			}
		}
		
		public function get items():Array
		{
			updateData();
			return data as Array;
		}
	}
}