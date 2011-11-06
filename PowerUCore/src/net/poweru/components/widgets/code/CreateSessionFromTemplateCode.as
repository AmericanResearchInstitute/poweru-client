package net.poweru.components.widgets.code
{
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.events.ResizeEvent;
	
	import net.poweru.components.dialogs.CreateSession;
	
	public class CreateSessionFromTemplateCode extends CreateSession
	{
		public var sessionTemplate:Object;
		
		public function CreateSessionFromTemplateCode()
		{
			super();
			removeEventListener(ResizeEvent.RESIZE, onResize);
			removeEventListener(CloseEvent.CLOSE, onClose);
		}
		
		override protected function onCreationComplete(event:FlexEvent):void
		{
			super.onCreationComplete(event);
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			populateControls();
		}
		
		// populate UI controls with data from the template
		protected function populateControls():void
		{
			if (sessionTemplate != null)
			{
				shortNameInput.text = sessionTemplate['shortname'];
				fullNameInput.text = sessionTemplate['fullname'];
				descriptionInput.text = sessionTemplate['description'];
				leadTimeInput.text = sessionTemplate['lead_time'];
			}
		}
		
		override protected function restrictStartDateRange():void
		{
			super.restrictStartDateRange();
			
			if (endDateInput.selectedDate != null)
				restrictEndDateRange();
			else
				verifySelectedDateRange();
		}
		
		override protected function restrictEndDateRange():void
		{
			super.restrictEndDateRange();
			verifySelectedDateRange();
		}
		
		// if selected dates are outside the event range, clear them
		protected function verifySelectedDateRange():void
		{
			// if selected dates are outside the specified range, clear them
			if (endDateInput.selectedDate > eventEnd || endDateInput.selectedDate < eventStart)
				endDateInput.selectedDate = null;
			if (endDateInput.selectedDate > eventEnd || endDateInput.selectedDate < eventStart)
				endDateInput.selectedDate = null;
			if (startDateInput.selectedDate > eventEnd || startDateInput.selectedDate < eventStart)
				startDateInput.selectedDate = null;
			if (startDateInput.selectedDate > eventEnd || startDateInput.selectedDate < eventStart)
				startDateInput.selectedDate = null;
		}
	}
}