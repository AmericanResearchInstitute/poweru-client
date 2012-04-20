package net.poweru.components.dialogs.code
{
	import mx.controls.DataGrid;
	import mx.events.CollectionEvent;
	
	import net.poweru.Places;
	import net.poweru.components.dialogs.BaseCRUDDialog;
	import net.poweru.components.parts.EditTaskFees;
	import net.poweru.events.ViewEvent;
	import net.poweru.model.ChooserRequest;
	import net.poweru.model.ChooserResult;
	import net.poweru.model.DataSet;
	import net.poweru.utils.ChooserRequestTracker;
	import net.poweru.utils.SortedDataSetFactory;
	
	/*	This is a base class for any editor dialog that needs to edit a
		subclass of Task. */
	public class BaseEditTaskCode extends BaseCRUDDialog
	{
		public var editTaskFees:EditTaskFees;
		[Bindable]
		public var achievements:DataGrid;
		[Bindable]
		public var prerequisiteTasks:DataGrid;
		[Bindable]
		public var prerequisiteAchievements:DataGrid;
		
		protected var pk:Number;
		
		[Bindable]
		protected var achievementDataSet:DataSet;
		[Bindable]
		protected var prerequisiteTaskDataSet:DataSet;
		[Bindable]
		protected var prerequisiteAchievementDataSet:DataSet;
		
		[Bindable]
		protected var chosenOrganization:Object;
		protected var prerequisiteChooserRequestTracker:ChooserRequestTracker;
		
		public function BaseEditTaskCode()
		{
			super();
			prerequisiteChooserRequestTracker = new ChooserRequestTracker();
			
			achievementDataSet = SortedDataSetFactory.singleFieldSort('name');
			achievementDataSet.addEventListener(CollectionEvent.COLLECTION_CHANGE, onControlChanged);
			prerequisiteTaskDataSet = SortedDataSetFactory.singleFieldSort('name');
			prerequisiteTaskDataSet.addEventListener(CollectionEvent.COLLECTION_CHANGE, onControlChanged);
			prerequisiteAchievementDataSet = SortedDataSetFactory.singleFieldSort('name');
			prerequisiteAchievementDataSet.addEventListener(CollectionEvent.COLLECTION_CHANGE, onControlChanged);
		}
		
		override public function clear():void
		{
			super.clear();
			
			pk = 0;
			chosenOrganization = null;
			achievementDataSet.source = [];
			achievementDataSet.refresh();
			prerequisiteTaskDataSet.source = [];
			prerequisiteTaskDataSet.refresh();
			prerequisiteAchievementDataSet.source = [];
			prerequisiteAchievementDataSet.refresh();
			editTaskFees.clear();
			changedControls = [];
		}
		
		public function populate(data:Object, ...args):void
		{
			pk = data['id'];
			updateControlIfUnchanged(achievementDataSet, 'source', data['achievements']);
			chosenOrganization = data['organization'];
			achievementDataSet.refresh();
			updateControlIfUnchanged(prerequisiteTaskDataSet, 'source', data['prerequisite_tasks']);
			prerequisiteTaskDataSet.refresh();
			updateControlIfUnchanged(prerequisiteAchievementDataSet, 'source', data['prerequisite_achievements']);
			prerequisiteAchievementDataSet.refresh();
			
			editTaskFees.taskID = pk;
			editTaskFees.dataSet = new DataSet(data['task_fees']);
		}
		
		override public function receiveChoice(choice:ChooserResult, chooserName:String):void
		{
			if (chooserRequestTracker.doIWantThis(chooserName, choice.requestID))
			{
				switch (chooserName)
				{
					case Places.CHOOSEACHIEVEMENT:
						if (achievementDataSet != null && achievementDataSet.findByPK(choice.value['id']) == null)
							achievementDataSet.addItem(choice.value);
						break;
					
					case Places.CHOOSEORGANIZATION:
						chosenOrganization = choice.value;
						break;
				}
			}
			else if (prerequisiteChooserRequestTracker.doIWantThis(chooserName, choice.requestID))
			{
				switch (chooserName)
				{
					case Places.CHOOSETASK:
						if (prerequisiteTaskDataSet != null && prerequisiteTaskDataSet.findByPK(choice.value['id']) == null)
							prerequisiteTaskDataSet.addItem(choice.value);
						break;
					
					case Places.CHOOSEACHIEVEMENT:
						if (prerequisiteAchievementDataSet != null && prerequisiteAchievementDataSet.findByPK(choice.value['id']) == null)
							prerequisiteAchievementDataSet.addItem(choice.value);
						break;
				}
			}
		}
		
		protected function onRemoveGrantedAchievement(event:Event):void
		{
			if (achievements.selectedItem != null)
			{
				achievementDataSet.removeByPK(achievements.selectedItem['id']);
				achievementDataSet.refresh();
			}
		}
		
		protected function onRemoveTask(event:Event):void
		{
			if (prerequisiteTasks.selectedItem != null)
			{
				prerequisiteTaskDataSet.removeByPK(prerequisiteTasks.selectedItem['id']);
				prerequisiteTaskDataSet.refresh();
			}
		}
		
		protected function onRemovePrerequisiteAchievement(event:Event):void
		{
			if (prerequisiteAchievements.selectedItem != null)
			{
				prerequisiteAchievementDataSet.removeByPK(prerequisiteAchievements.selectedItem['id']);
				prerequisiteAchievementDataSet.refresh();
			}
		}
		
		protected function onAddPrerequisiteAchievement(event:Event):void
		{
			var request:ChooserRequest = prerequisiteChooserRequestTracker.getChooserRequest(
				Places.CHOOSEACHIEVEMENT,
				achievementDataSet.toArray()
			); 
			
			dispatchEvent(new ViewEvent(ViewEvent.SHOWDIALOG, [Places.CHOOSEACHIEVEMENT, request]));
		}
		
		protected function onAddGrantedAchievement(event:Event):void
		{
			var request:ChooserRequest = chooserRequestTracker.getChooserRequest(
				Places.CHOOSEACHIEVEMENT,
				prerequisiteAchievementDataSet.toArray()
			); 
			
			dispatchEvent(new ViewEvent(ViewEvent.SHOWDIALOG, [Places.CHOOSEACHIEVEMENT, request]));
		}
	}
}