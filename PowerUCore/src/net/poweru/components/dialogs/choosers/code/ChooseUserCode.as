package net.poweru.components.dialogs.choosers.code
{
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.controls.AdvancedDataGrid;
	import mx.controls.ComboBox;
	import mx.events.FlexEvent;
	import mx.utils.ObjectUtil;
	
	import net.poweru.Constants;
	import net.poweru.components.dialogs.BaseDialog;
	import net.poweru.components.dialogs.choosers.interfaces.IChooser;
	import net.poweru.model.DataSet;
	import net.poweru.utils.CompareLabels;
	
	public class ChooseUserCode extends BaseDialog implements IChooser
	{
		[Bindable]
		public var grid:AdvancedDataGrid;
		[Bindable]
		public var statusFilterCB:ComboBox;
		[Bindable]
		public var orgFilterCB:ComboBox;
		
		public function ChooseUserCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		/*	args[0] is user status choices
			args[1] is organizations	*/
		public function populate(data:Array, ...args):void
		{
			grid.dataProvider.source = data;
			grid.dataProvider.refresh();
			statusFilterCB.dataProvider.source = ObjectUtil.copy(args[0] as Array);
			statusFilterCB.dataProvider.source.push(Constants.ALL);
			statusFilterCB.dataProvider.refresh();
			orgFilterCB.dataProvider.source = ObjectUtil.copy(args[1] as Array);
			orgFilterCB.dataProvider.source.push({'name':Constants.ALL});
			orgFilterCB.dataProvider.source.push({'name':Constants.NONE});
			orgFilterCB.dataProvider.refresh();
		}
		
		public function clear():void
		{
			populate([], [], []);
		}
		
		// Filter based on selections in the filter controls
		protected function filterBulkUsers(item:Object):Boolean
		{
			var ret:Boolean = true;
			
			switch (statusFilterCB.selectedLabel)
			{
				// Leave it as true
				case Constants.ALL:
					break;
				
				// true if user has selected status
				default:
					ret = Boolean(statusFilterCB.selectedLabel == item['status']);
			}
			
			if (ret)
			{
				var orgAssociations:DataSet = new DataSet(item['owned_userorgroles'] as Array);
				
				switch (orgFilterCB.selectedLabel)
				{
					// Leave it as true
					case Constants.ALL:
						break;
					
					// true only if there are no org associations
					case Constants.NONE:
						ret = Boolean(orgAssociations.length == 0);
						break;
					
					// true if selected org is found among user's org associations
					default:
						ret = Boolean(orgAssociations.findByKey('organization_name', orgFilterCB.selectedLabel) != null);
				}
			}
			
			return ret;
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			grid.dataProvider = new DataSet();
			grid.dataProvider.filterFunction = filterBulkUsers;
			statusFilterCB.dataProvider = new DataSet();
			orgFilterCB.dataProvider = new DataSet();
			
			var statusSort:Sort = new Sort();
			statusSort.compareFunction = CompareLabels;
			statusFilterCB.dataProvider.sort = statusSort;
			
			var orgSort:Sort = new Sort();
			orgSort.compareFunction = CompareLabels;
			orgSort.fields = [new SortField('name')];
			orgFilterCB.dataProvider.sort = orgSort;
		}
	}
}