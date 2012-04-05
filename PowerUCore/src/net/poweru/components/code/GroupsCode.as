package net.poweru.components.code
{
	import mx.containers.HBox;
	
	import net.poweru.components.interfaces.IArrayPopulatedComponent;
	import net.poweru.model.DataSet;
	import net.poweru.utils.SortedDataSetFactory;

	public class GroupsCode extends BaseComponent implements IArrayPopulatedComponent
	{
		[Bindable]
		protected var dataProvider:DataSet;
		
		public function GroupsCode()
		{
			super();
			dataProvider = SortedDataSetFactory.singleFieldSort('name');
		}
		
		public function populate(groups:Array):void
		{
			dataProvider.source = groups;
			dataProvider.refresh();
		}
		
		public function clear():void
		{
			populate([]);
		}
		
	}
}