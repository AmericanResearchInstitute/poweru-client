package net.poweru.components.dialogs.code
{
	import mx.collections.ArrayCollection;
	import mx.controls.AdvancedDataGrid;
	import mx.events.FlexEvent;
	
	import net.poweru.components.dialogs.BaseCRUDDialog;
	import net.poweru.components.interfaces.IEditDialog;
	import net.poweru.model.DataSet;
	
	public class AddTasksToCurriculumCode extends BaseCRUDDialog implements IEditDialog
	{
		public var choicesGrid:AdvancedDataGrid;
		public var selectedGrid:AdvancedDataGrid;
		protected var curriculum:Object;
		protected var currentTaskIDs:ArrayCollection;
		
		public function AddTasksToCurriculumCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			validators = [];
		}
		
		public function populate(data:Object, ...args):void
		{
			if (choicesGrid.dataProvider != null && selectedGrid.dataProvider != null)
				clear();
			curriculum = data;
			currentTaskIDs = new ArrayCollection;
			for each (var item:Object in (data.tasks as Array))
				currentTaskIDs.addItem(item.id);
			choicesGrid.dataProvider.source = args[0];
			choicesGrid.dataProvider.refresh();
		}
		
		public function clear():void
		{
			choicesGrid.dataProvider.source = [];
			choicesGrid.dataProvider.refresh();
			selectedGrid.dataProvider.source = [];
			selectedGrid.dataProvider.refresh();
		}
		
		override public function getData():Object
		{
			var tasks:Array = curriculum.task_relationships as Array;
			if (tasks == null)
				tasks = []
			for each (var item:Object in (selectedGrid.dataProvider as ArrayCollection))
			{
				var newItem:Object = {
					'task' : item['id']
				};
				tasks.push(newItem);
			}
			curriculum['curriculum_task_associations'] = tasks;
			return curriculum;
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			choicesGrid.dataProvider = new DataSet();
			choicesGrid.dataProvider.filterFunction = filterAlreadyChosenTasks;
		}
		
		protected function filterAlreadyChosenTasks(item:Object):Boolean
		{
			return !currentTaskIDs.contains(item.id);
		}
	}
}