package net.poweru.components.dialogs.code
{
	import com.yahoo.astra.mx.controls.TimeInput;
	import com.yahoo.astra.mx.core.yahoo_mx_internal;
	
	import mx.controls.DateField;
	import mx.controls.TextArea;
	import mx.controls.TextInput;
	import mx.events.FlexEvent;
	
	import net.poweru.components.dialogs.BaseCRUDDialog;
	import net.poweru.components.interfaces.ICreateSession;
	import net.poweru.generated.model.Session.NameInput;
	import net.poweru.generated.model.Session.TitleInput;
	import net.poweru.generated.model.Session.UrlInput;
	
	public class CreateSessionCode extends BaseCRUDDialog implements ICreateSession
	{
		public var nameInput:NameInput;
		public var titleInput:TitleInput;
		public var startDateInput:DateField;
		public var startTimeInput:TimeInput;
		public var endDateInput:DateField;
		public var endTimeInput:TimeInput;
		public var leadTimeInput:TextInput;
		public var urlInput:UrlInput;
		public var descriptionInput:TextArea;
		
		protected var event:Object;
		
		public function CreateSessionCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		override public function getData():Object
		{
			return {
				'event' : event['id'],
				'name' : nameInput.text,
				'title' : titleInput.text,
				'lead_time' : leadTimeInput.text,
				'url' : urlInput.text,
				'description' : descriptionInput.text,
				'status' : 'active',
				'default_price' : 0,
				'confirmed' : true,
				'start' : new Date(
					startDateInput.selectedDate.fullYear,
					startDateInput.selectedDate.month,
					startDateInput.selectedDate.date,
					startTimeInput.value.hours,
					startTimeInput.value.minutes
				),
				'end' : new Date(
					endDateInput.selectedDate.fullYear,
					endDateInput.selectedDate.month,
					endDateInput.selectedDate.date,
					endTimeInput.value.hours,
					endTimeInput.value.minutes
				)
			};
		}
		
		public function populateEventData(data:Object):void
		{
			event = data;
		}
		
		public function clear():void
		{
			nameInput.text = '';
			titleInput.text = '';
			leadTimeInput.text = '';
			descriptionInput.text = '';
			startDateInput.selectedDate = null;
			startTimeInput.value = new Date();
			endDateInput.selectedDate = null;
			endTimeInput.value = new Date();
			event = null;
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			validators = [
				nameInput.validator,
				titleInput.validator,
				urlInput.validator
			];
			focusManager.setFocus(nameInput);
		}
	}
}