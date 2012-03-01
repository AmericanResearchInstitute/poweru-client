package net.poweru.components.code
{
	import mx.containers.HBox;
	
	import net.poweru.components.interfaces.IArrayPopulatedComponent;
	import net.poweru.model.DataSet;

	public class GroupsCode extends HBox implements IArrayPopulatedComponent
	{
		[Bindable]
		protected var dataProvider:DataSet;
		
		public function GroupsCode()
		{
			super();
			dataProvider = new DataSet();
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