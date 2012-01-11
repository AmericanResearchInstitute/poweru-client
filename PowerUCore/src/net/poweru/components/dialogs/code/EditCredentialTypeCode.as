package net.poweru.components.dialogs.code
{
	import flash.events.Event;
	
	import mx.controls.List;
	import mx.controls.TextArea;
	import mx.events.FlexEvent;
	
	import net.poweru.Places;
	import net.poweru.components.dialogs.BaseCRUDDialog;
	import net.poweru.components.interfaces.IEditDialog;
	import net.poweru.generated.model.CredentialType.NameInput;
	import net.poweru.model.DataSet;
	
	public class EditCredentialTypeCode extends BaseCRUDDialog implements IEditDialog
	{
		public var nameInput:NameInput;
		public var descriptionInput:TextArea;
		[Bindable]
		public var achievementsList:List;
		
		protected var pk:Number;
		
		public function EditCredentialTypeCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		protected function get achievementsDataSet():DataSet
		{
			return achievementsList.dataProvider as DataSet;
		}
		
		public function clear():void
		{
			pk = Number.NaN;
			nameInput.text = '';
			descriptionInput.text = '';
			
			achievementsList.dataProvider.source = [];
			achievementsList.dataProvider.refresh();
		}
		
		public function populate(data:Object, ...args):void
		{
			pk = data['id'];
			nameInput.text = data['name'];
			descriptionInput.text = data['description'];
			
			achievementsDataSet.source = data['required_achievements'];
			achievementsDataSet.refresh();
		}
		
		override public function getData():Object
		{
			return {
				'id' : pk,
				'name' : nameInput.text,
				'description' : descriptionInput.text,
				'required_achievements' : achievementsList.dataProvider.toArray()
			};
		}
		
		override public function receiveChoice(choice:Object, chooserName:String):void
		{
			if (chooserName == Places.CHOOSEACHIEVEMENT)
			{
				achievementsDataSet.addOrReplace(choice);
				achievementsDataSet.refresh();
			}
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			achievementsList.dataProvider = new DataSet();
			focusManager.setFocus(nameInput);
			validators = [nameInput.validator];
		}
		
		protected function onRemove(event:Event):void
		{
			if (achievementsList.selectedItem != null)
			{
				achievementsDataSet.removeByPK(achievementsList.selectedItem['id']);
				achievementsDataSet.refresh();
			}
		}
	}
}