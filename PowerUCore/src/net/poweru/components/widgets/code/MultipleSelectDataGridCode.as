package net.poweru.components.widgets.code
{
	import net.poweru.model.DataSet;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.controls.DataGrid;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.validators.NumberValidator;

	public class MultipleSelectDataGridCode extends DataGrid implements IMultipleSelect
	{
		public static const SELECTEDSTRING:String = 'MULTIPLESELECT_selected';
		
		public var checkBoxColumn:DataGridColumn;
		[Bindable]
		protected var _selectedStuff:DataSet;
		[Bindable]
		public var _validator:NumberValidator;
		
		public function MultipleSelectDataGridCode()
		{
			super();
			dataProvider = new DataSet();
			_selectedStuff = new DataSet();
		}
		
		public function get validator():NumberValidator
		{
			return _validator;
		}
		
		// convenience method to cast the dataProvider
		protected function get dataSet():DataSet
		{
			return dataProvider as DataSet;
		}
		
		// Add our check box's column, and add an event listener
		protected function onCreationComplete(event:Event):void
		{
			if (columns.indexOf(checkBoxColumn) == -1)
			{
				var ac:ArrayCollection = new ArrayCollection(columns);
				ac.addItemAt(checkBoxColumn, 0);
				columns = ac.toArray();
			}
			addEventListener(Event.CHANGE, onSelectChange);
		}
		
		public function populate(choices:Array, selectedItems:Array):void
		{
			cleanup();
			
			dataProvider.source = choices;
			dataProvider.refresh();
			_selectedStuff.source = selectedItems;
			_selectedStuff.refresh();
			
			for each (var item:Object in dataSet)
			{
				item[SELECTEDSTRING] = (_selectedStuff.findByPK(item['id']) != null);
			}
		}
		
		override public function get selectedItems():Array
		{
			return _selectedStuff.toArray();
		}
		
		override public function set selectedItems(items:Array):void
		{
			throw new Error('This attribute may not be set directly.  Use the populate() method');
		}
		
		// Remove the attribute we added that helped us keep track of what is an isn't selected
		protected function cleanup():void
		{
			for each (var item:Object in dataSet)
				delete item[SELECTEDSTRING];
		}
		
		// when an item is checked or unchecked, add it to or remove it from _selectedStuff
		public function onSelectChange(event:Event):void
		{
			var pk:Number = event['itemRenderer']['data']['id'];
			if (_selectedStuff.findByPK(pk) == null)
				_selectedStuff.addItem(dataSet.findByPK(pk));
			else
				_selectedStuff.removeByPK(pk);
		}
		
	}
}