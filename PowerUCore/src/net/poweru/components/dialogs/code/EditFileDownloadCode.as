package net.poweru.components.dialogs.code
{
	import mx.containers.Form;
	import mx.controls.CheckBox;
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
		[Bindable]
		public var activeInput:CheckBox;
		
		protected var activeInputWasPopulated:Boolean;
		
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
			activeInput.selected = true;
			activeInputWasPopulated = false;
		}
		
		override public function populate(data:Object, ...args):void
		{
			super.populate.apply(this, [data].concat(args));
			
			updateControlIfUnchanged(nameInput, 'text', data['name']);
			updateControlIfUnchanged(titleInput, 'text', data['title']);
			updateControlIfUnchanged(descriptionInput, 'text', data['description']);
			if (data.hasOwnProperty('active'))
			{
				activeInput.selected = data['active'];
				activeInputWasPopulated = true;
			}
		}
		
		override public function getData():Object
		{
			var ret:Object = {
				'id' : pk,
				'name' : nameInput.text,
				'title' : titleInput.text,
				'description' : descriptionInput.text,
				'achievements' : achievementDataSet.toArray(),
				'prerequisite_tasks' : prerequisiteTaskDataSet.toArray(),
				'prerequisite_achievements' : prerequisiteAchievementDataSet.toArray(),
				'organization' : chosenOrganization.id
			};
			if (activeInputWasPopulated)
				ret['active'] = activeInput.selected;
			return ret;
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