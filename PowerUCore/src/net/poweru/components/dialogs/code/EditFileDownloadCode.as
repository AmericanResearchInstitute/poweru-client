package net.poweru.components.dialogs.code
{
	import mx.containers.Form;
	import mx.controls.TextArea;
	import mx.events.FlexEvent;
	
	import net.poweru.components.interfaces.IEditDialog;
	import net.poweru.generated.interfaces.IGeneratedTextInput;
	
	public class EditFileDownloadCode extends BaseEditTaskCode implements IEditDialog
	{
		public var nameInput:IGeneratedTextInput;
		public var titleInput:IGeneratedTextInput;
		public var descriptionInput:TextArea;
		
		public var form:Form;
		
		public function EditFileDownloadCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		override public function clear():void
		{
			super.clear();
			
			nameInput.text = '';
			titleInput.text = '';
			descriptionInput.text = '';
		}
		
		override public function populate(data:Object, ...args):void
		{
			super.populate.apply(this, [data].concat(args));
			
			updateControlIfUnchanged(nameInput, 'text', data['name']);
			updateControlIfUnchanged(titleInput, 'text', data['title']);
			updateControlIfUnchanged(descriptionInput, 'text', data['description']);
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
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			validators = validators.concat([
				nameInput.validator,
				titleInput.validator
			]);
			addControlChangeListener(form);
		}
	}
}