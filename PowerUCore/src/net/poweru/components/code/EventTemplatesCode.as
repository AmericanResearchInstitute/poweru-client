package net.poweru.components.code
{
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.containers.HBox;
	import mx.controls.AdvancedDataGrid;
	import mx.controls.CheckBox;
	import mx.controls.List;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;
	
	import net.poweru.components.interfaces.IEventTemplates;
	import net.poweru.events.ViewEvent;
	import net.poweru.model.DataSet;
	import net.poweru.utils.SortedDataSetFactory;
	
	public class EventTemplatesCode extends BaseComponent implements IEventTemplates
	{
		[Bindable]
		public var grid:AdvancedDataGrid;
		[Bindable]
		public var sessionTemplateList:List;
		[Bindable]
		public var showInactiveInput:CheckBox;
		
		public function EventTemplatesCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		public function populate(data:Array):void
		{
			grid.dataProvider.source = data;
			grid.dataProvider.refresh();
			sessionTemplateList.dataProvider.source = [];
			sessionTemplateList.dataProvider.refresh();
		}
		
		public function clear():void
		{
			populate([]);
			sessionTemplateList.dataProvider.source = [];
			sessionTemplateList.dataProvider.refresh();
		}
		
		public function setSessionTemplates(data:Array):void
		{	
			var dataMatchesCurrentSelection:Boolean = true;
			var currentID:Number = grid.selectedItem['id'];
			
			// make sure data we receive is the data we currently want
			for each (var item:Object in data)
			{
				if (item['event_template'] != currentID)
				{
					dataMatchesCurrentSelection = false;
					break;
				}
			}
			
			if (dataMatchesCurrentSelection)
			{
				var currentData:DataSet = new DataSet(sessionTemplateList.dataProvider.toArray());
				currentData.mergeData(data);
				sessionTemplateList.dataProvider.source = currentData.toArray();
				sessionTemplateList.dataProvider.refresh();
			}	
		}
		
		protected function filterInactive(item:Object):Boolean
		{
			if (showInactiveInput != null && showInactiveInput.selected == true)
				return true;
			else
				return !(item.hasOwnProperty('active') && item.active == false);
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			grid.dataProvider = SortedDataSetFactory.singleFieldSort('name_prefix');
			grid.dataProvider.filterFunction = filterInactive;
			sessionTemplateList.dataProvider = new DataSet();
			var sort:Sort = new Sort();
			sort.fields = [new SortField('sequence', false, false, true)];
			sessionTemplateList.dataProvider.sort = sort;
		}
		
		protected function onEventTemplateSelected(event:ListEvent):void
		{
			sessionTemplateList.dataProvider.source = [];
			sessionTemplateList.dataProvider.refresh();
			dispatchEvent(new ViewEvent(ViewEvent.FETCH, (event.target as AdvancedDataGrid).selectedItem['session_templates']));
		}
	}
}