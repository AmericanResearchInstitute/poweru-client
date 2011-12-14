package net.poweru.components.dialogs.code
{
	import flash.events.Event;
	
	import mx.controls.DataGrid;
	import mx.controls.TextArea;
	import mx.events.FlexEvent;
	
	import net.poweru.Places;
	import net.poweru.components.dialogs.BaseCRUDDialog;
	import net.poweru.components.interfaces.IEditDialog;
	import net.poweru.generated.interfaces.IGeneratedTextInput;
	import net.poweru.model.DataSet;
	
	public class EditFileDownloadCode extends BaseCRUDDialog implements IEditDialog
	{
		public var nameInput:IGeneratedTextInput;
		public var titleInput:IGeneratedTextInput;
		public var descriptionInput:TextArea;
		[Bindable]
		public var achievements:DataGrid;
		
		[Bindable]
		protected var achievementDataSet:DataSet;
		protected var pk:Number;
		
		public function EditFileDownloadCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		public function clear():void
		{
			pk = 0;
			nameInput.text = '';
			titleInput.text = '';
			descriptionInput.text = '';
			achievementDataSet.source = [];
			achievementDataSet.refresh();
		}
		
		public function populate(data:Object, ...args):void
		{
			pk = data['id'];
			nameInput.text = data['name'];
			titleInput.text = data['title'];
			descriptionInput.text = data['description'];
			achievementDataSet.source = data['achievements'];
			achievementDataSet.refresh();
		}
		
		override public function getData():Object
		{
			return {
				'id' : pk,
				'name' : nameInput.text,
				'title' : titleInput.text,
				'description' : descriptionInput.text,
				'achievements' : achievementDataSet.toArray()
			}
		}
		
		override public function receiveChoice(choice:Object, chooserName:String):void
		{
			if (chooserName == Places.CHOOSEACHIEVEMENT && achievementDataSet != null && achievementDataSet.findByPK(choice['id']) == null)
			{
				achievementDataSet.addItem(choice);
			}
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			achievementDataSet = new DataSet();
			validators = [nameInput.validator, titleInput.validator];
		}
		
		protected function onRemove(event:Event):void
		{
			if (achievements.selectedItem != null)
			{
				achievementDataSet.removeByPK(achievements.selectedItem['id']);
				achievementDataSet.refresh();
			}
		}
	}
}