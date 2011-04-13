package net.poweru.components.code
{
	import mx.containers.HBox;
	
	import net.poweru.components.interfaces.IGroups;
	import net.poweru.model.DataSet;

	public class GroupsCode extends HBox implements IGroups
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
		
	}
}