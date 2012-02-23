package net.poweru.components.parts.code
{
	import mx.containers.VBox;
	import mx.controls.DataGrid;
	
	import net.poweru.model.DataSet;
	
	public class EditTaskFeesCode extends VBox
	{
		[Bindable]
		public var grid:DataGrid;
		[Bindable]
		public var dataSet:DataSet;
		public var taskID:Number;
		
		public function EditTaskFeesCode()
		{
			super();
		}
		
		public function clear():void
		{
			dataSet = new DataSet();
			taskID = Number.NaN;
		}
	}
}