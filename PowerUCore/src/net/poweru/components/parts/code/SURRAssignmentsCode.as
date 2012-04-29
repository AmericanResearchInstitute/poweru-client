package net.poweru.components.parts.code
{
	import mx.containers.VBox;
	
	import net.poweru.model.DataSet;
	import net.poweru.utils.SortedDataSetFactory;
	
	public class SURRAssignmentsCode extends VBox
	{
		[Bindable]
		public var assignments:DataSet;
		
		public function SURRAssignmentsCode()
		{
			super();
			init();
		}
		
		private function init():void
		{
			assignments = SortedDataSetFactory.singleFieldSort('last_name');
		}
	}
}