package net.poweru.components.dialogs.code
{
	import mx.controls.DataGrid;
	import mx.controls.TextArea;
	import mx.events.FlexEvent;
	
	import net.poweru.Places;
	import net.poweru.components.dialogs.BaseCRUDDialog;
	import net.poweru.components.interfaces.IEditDialog;
	import net.poweru.generated.interfaces.IGeneratedTextInput;
	import net.poweru.model.DataSet;
	
	public class EditExamCode extends BaseCRUDDialog implements IEditDialog
	{
		public var nameInput:IGeneratedTextInput;
		public var titleInput:IGeneratedTextInput;
		public var descriptionInput:TextArea;
		protected var pk:Number;
		[Bindable]
		public var achievements:DataGrid;
		[Bindable]
		public var prerequisites:DataGrid;
		[Bindable]
		protected var achievementDataSet:DataSet;
		[Bindable]
		protected var prerequisiteDataSet:DataSet;
		
		public function EditExamCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		public function clear():void
		{
			nameInput.text = '';
			titleInput.text = '';
			descriptionInput.text = '';
			achievementDataSet.source = [];
			achievementDataSet.refresh();
			prerequisiteDataSet.source = [];
			prerequisiteDataSet.refresh();
		}
		
		override public function getData():Object
		{
			return {
				'id' : pk,
				'name' : nameInput.text,
				'title' : titleInput.text,
				'description' : descriptionInput.text,
				'achievements' : achievementDataSet.toArray(),
				'prerequisite_tasks' : prerequisiteDataSet.toArray()
			}
		}
		
		public function populate(data:Object, ...args):void
		{
			pk = data['id'];
			nameInput.text = data['name'];
			titleInput.text = data['title'];
			descriptionInput.text = data['description'];
			achievementDataSet.source = data['achievements'];
			achievementDataSet.refresh();
			prerequisiteDataSet.source = data['prerequisite_tasks'];
			prerequisiteDataSet.refresh();
			
			title = 'Edit Exam ' + data['name'];
		}
		
		override public function receiveChoice(choice:Object, chooserName:String):void
		{
			switch (chooserName)
			{
				case Places.CHOOSEACHIEVEMENT:
					if (achievementDataSet != null && achievementDataSet.findByPK(choice['id']) == null)
						achievementDataSet.addItem(choice);
					break;
				
				case Places.CHOOSETASK:
					if (prerequisiteDataSet != null && prerequisiteDataSet.findByPK(choice['id']) == null)
						prerequisiteDataSet.addItem(choice);
					break;
			}
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			validators = [nameInput.validator, titleInput.validator];
			achievementDataSet = new DataSet();
			prerequisiteDataSet = new DataSet();
		}
		
		protected function onRemoveAchievement(event:Event):void
		{
			if (achievements.selectedItem != null)
			{
				achievementDataSet.removeByPK(achievements.selectedItem['id']);
				achievementDataSet.refresh();
			}
		}
		
		protected function onRemoveTask(event:Event):void
		{
			if (prerequisites.selectedItem != null)
			{
				prerequisiteDataSet.removeByPK(prerequisites.selectedItem['id']);
				prerequisiteDataSet.refresh();
			}
		}
	}
}