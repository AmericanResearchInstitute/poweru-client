package net.poweru.components.vod.code
{
	import mx.containers.HBox;
	
	import net.poweru.components.interfaces.IArrayPopulatedComponent;
	import net.poweru.model.DataSet;
	import net.poweru.utils.SortedDataSetFactory;
	import net.poweru.components.code.BaseComponent;

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