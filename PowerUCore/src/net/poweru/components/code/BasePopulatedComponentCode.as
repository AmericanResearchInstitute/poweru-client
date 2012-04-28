package net.poweru.components.code
{
	import mx.containers.HBox;
	import mx.controls.DataGrid;
	import mx.events.FlexEvent;
	
	import net.poweru.Constants;
	import net.poweru.components.interfaces.IArrayPopulatedComponent;
	import net.poweru.model.DataSet;
	import net.poweru.utils.SortedDataSetFactory;
	
	public class BasePopulatedComponentCode extends HBox implements IArrayPopulatedComponent
	{
		[Bindable]
		public var grid:DataGrid;
		// The default datagrid will sort by this field, which can be a nested field.
		public var sortedFieldName:String;
		
		public function BasePopulatedComponentCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		public function populate(data:Array):void
		{
			if (grid != null && grid.dataProvider != null)
			{
				grid.dataProvider.source = data;
				grid.dataProvider.refresh();
			}
		}
		
		public function clear():void
		{
			populate([]);
		}
		
		public function setState(state:String):void
		{
			try
			{
				currentState = state;
			}
			catch (err:ArgumentError)
			{
				; // If the state isn't defined, no sweat. Stick with the default.
			}
		}
		
		/*	Returns true if the logged in user has permission to edit the
			object. Looks for a specific attribute added by the proxy. */
		protected function isEditable(item:Object):Boolean
		{
			return !item.hasOwnProperty(Constants.NOT_EDITABLE_FIELD_NAME);
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			grid.dataProvider = getNewDataSet();
		}
		
		// Here in case a subclass wants something more special
		protected function getNewDataSet():DataSet
		{
			return SortedDataSetFactory.singleFieldSort(sortedFieldName);
		}
	}
}