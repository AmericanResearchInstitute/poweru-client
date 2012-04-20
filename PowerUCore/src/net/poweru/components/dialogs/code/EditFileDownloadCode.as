package net.poweru.components.dialogs.code
{
	import flash.events.Event;
	
	import mx.containers.Form;
	import mx.controls.DataGrid;
	import mx.controls.TextArea;
	import mx.events.CollectionEvent;
	import mx.events.FlexEvent;
	
	import net.poweru.Places;
	import net.poweru.components.dialogs.BaseCRUDDialog;
	import net.poweru.components.interfaces.IEditDialog;
	import net.poweru.components.parts.EditTaskFees;
	import net.poweru.events.ViewEvent;
	import net.poweru.generated.interfaces.IGeneratedTextInput;
	import net.poweru.model.ChooserRequest;
	import net.poweru.model.ChooserResult;
	import net.poweru.model.DataSet;
	import net.poweru.utils.ChooserRequestTracker;
	import net.poweru.utils.SortedDataSetFactory;
	
	public class EditFileDownloadCode extends BaseCRUDDialog implements IEditDialog
	{
		public var nameInput:IGeneratedTextInput;
		public var titleInput:IGeneratedTextInput;
		public var descriptionInput:TextArea;
		[Bindable]
		public var achievements:DataGrid;
		[Bindable]
		public var prerequisiteTasks:DataGrid;
		[Bindable]
		public var prerequisiteAchievements:DataGrid;
		public var editTaskFees:EditTaskFees;
		public var form:Form;
		
		[Bindable]
		protected var achievementDataSet:DataSet;
		[Bindable]
		protected var prerequisiteTaskDataSet:DataSet;
		[Bindable]
		protected var prerequisiteAchievementDataSet:DataSet;
		protected var pk:Number;
		[Bindable]
		protected var chosenOrganization:Object;
		protected var prerequisiteChooserRequestTracker:ChooserRequestTracker;
		
		public function EditFileDownloadCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
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
			pk = 0;
			nameInput.text = '';
			titleInput.text = '';
			descriptionInput.text = '';
			chosenOrganization = null;
			achievementDataSet.source = [];
			achievementDataSet.refresh();
			prerequisiteTaskDataSet.source = [];
			prerequisiteTaskDataSet.refresh();
			editTaskFees.clear();
			
			super.clear();
		}
		
		public function populate(data:Object, ...args):void
		{
			pk = data['id'];
			updateControlIfUnchanged(nameInput, 'text', data['name']);
			updateControlIfUnchanged(titleInput, 'text', data['title']);
			updateControlIfUnchanged(descriptionInput, 'text', data['description']);
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
		
		override public function getData():Object
		{
			return {
				'id' : pk,
				'name' : nameInput.text,
				'title' : titleInput.text,
				'description' : descriptionInput.text,
				'achievements' : achievementDataSet.toArray(),
				'prerequisite_tasks' : prerequisiteTaskDataSet.toArray(),
				'prerequisite_achievements' : prerequisiteAchievementDataSet.toArray(),
				'organization' : chosenOrganization.id
			}
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
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			validators = validators.concat([
				nameInput.validator,
				titleInput.validator
			]);
			addControlChangeListener(form);
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