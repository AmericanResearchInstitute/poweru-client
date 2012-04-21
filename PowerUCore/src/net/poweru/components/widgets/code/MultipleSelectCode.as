package net.poweru.components.widgets.code
{
	import flash.events.Event;
	
	import mx.containers.VBox;
	import mx.controls.CheckBox;
	import mx.utils.ObjectUtil;
	import mx.validators.NumberValidator;
	
	import net.poweru.model.DataSet;

	public class MultipleSelectCode extends VBox implements IMultipleSelect
	{
		[Bindable]
		protected var selectedItemsDataSet:DataSet;
		[Bindable]
		protected var choicesDataSet:DataSet;
		[Bindable]
		public var labelField:String;
		[Bindable]
		public var _validator:NumberValidator;
		
		public function MultipleSelectCode()
		{
			super();
			init();
		}
		
		private function init():void
		{
			choicesDataSet = new DataSet();
			selectedItemsDataSet = new DataSet();
		}
		
		public function get selectedItems():Array
		{
			return selectedItemsDataSet.toArray();
		}
		
		public function set selectedItems(data:Array):void
		{
			selectedItemsDataSet.source = data;
			selectedItemsDataSet.refresh();
		}
		
		public function set choices(data:Array):void
		{
			choicesDataSet.source = data;
			choicesDataSet.refresh();
		}
		
		public function get validator():NumberValidator
		{
			return _validator;
		}
		
		protected function onSelectChange(event:Event):void
		{
			var cb:CheckBox = event.target as CheckBox;
			for each (var item:Object in choicesDataSet)
				if (item[labelField] == cb.label)
				{
					if (cb.selected)
						selectedItemsDataSet.addOrReplace(ObjectUtil.copy(item));
					else
						selectedItemsDataSet.removeByPK(item['id']);
				}
		}
		
		protected function removeCheckBoxes():void
		{
			for each (var cb:CheckBox in getChildren())
			{
				removeChild(cb);
				cb.removeEventListener(Event.CHANGE, onSelectChange);
			}
		}
		
		protected function createCheckBoxes():void
		{
			for each (var choice:Object in choicesDataSet)
			{
				var cb:CheckBox = new CheckBox();
				cb.label = choice[labelField];
				cb.selected = selectedItemsDataSet.findByPK(choice['id']) != null;
				cb.addEventListener(Event.CHANGE, onSelectChange);
				addChild(cb);
			}
		}
		
		public function populate(choices:Array, selectedItems:Array):void
		{
			this.choices = choices;
			this.selectedItems = selectedItems;
			removeCheckBoxes();
			createCheckBoxes();
		}
		
	}
}