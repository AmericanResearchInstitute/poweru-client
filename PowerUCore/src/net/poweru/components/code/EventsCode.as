package net.poweru.components.code
{
	import mx.containers.HBox;
	import mx.controls.AdvancedDataGrid;
	import mx.controls.List;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;
	
	import net.poweru.components.interfaces.IEvents;
	import net.poweru.events.ViewEvent;
	import net.poweru.model.DataSet;
	
	public class EventsCode extends HBox implements IEvents
	{
		[Bindable]
		public var grid:AdvancedDataGrid;
		[Bindable]
		public var sessionList:List;
		
		public function EventsCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		public function populate(data:Array):void
		{
			grid.dataProvider.source = data;
			grid.dataProvider.refresh();
			sessionList.dataProvider.source = [];
			sessionList.dataProvider.refresh();
		}
		
		public function clear():void
		{
			populate([]);
			sessionList.dataProvider.source = [];
			sessionList.dataProvider.refresh();
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			grid.dataProvider = new DataSet();
			sessionList.dataProvider = new DataSet();
		}
		
		public function setSessions(data:Array):void
		{
			var dataMatchesCurrentSelection:Boolean = true;
			var currentID:Number = grid.selectedItem['id'];
			
			// make sure data we receive is the data we currently want
			for each (var item:Object in data)
			{
				if (item['event'] != currentID)
				{
					dataMatchesCurrentSelection = false;
					break;
				}
			}
			
			if (dataMatchesCurrentSelection)
			{
				var currentData:DataSet = new DataSet(sessionList.dataProvider.toArray());
				currentData.mergeData(data);
				sessionList.dataProvider.source = currentData.toArray();
				sessionList.dataProvider.refresh();
			}
		}
		
		protected function onEventSelected(event:ListEvent):void
		{
			sessionList.dataProvider.source = [];
			sessionList.dataProvider.refresh();
			dispatchEvent(new ViewEvent(ViewEvent.FETCH, (event.target as AdvancedDataGrid).selectedItem['sessions']));
		}
	}
}