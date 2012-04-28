package net.poweru.components.dialogs.code
{
	import mx.controls.DataGrid;
	
	import net.poweru.components.dialogs.BaseDialog;
	import net.poweru.components.interfaces.IArrayPopulatedComponent;
	import net.poweru.model.DataSet;
	import net.poweru.utils.SortedDataSetFactory;
	
	public class CurriculumEnrollmentUsersCode extends BaseDialog implements IArrayPopulatedComponent
	{
		public var grid:DataGrid;
		[Bindable]
		protected var dp:DataSet;
		
		public function CurriculumEnrollmentUsersCode()
		{
			super();
			init();
		}
		
		private function init():void
		{
			dp = SortedDataSetFactory.singleFieldSort('last_name');
		}
		
		public function populate(data:Array):void
		{
			dp.source = data;
			dp.refresh();
		}
		
		public function clear():void
		{
			populate([]);
		}
	}
}