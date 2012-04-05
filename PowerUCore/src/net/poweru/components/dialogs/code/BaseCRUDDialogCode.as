package net.poweru.components.dialogs.code
{
	import flash.events.Event;
	
	import mx.containers.Form;
	import mx.containers.FormItem;
	import mx.controls.Button;
	import mx.validators.Validator;
	
	import net.poweru.components.dialogs.BaseDialog;
	import net.poweru.events.ViewEvent;
	import net.poweru.model.ChooserResult;
	import net.poweru.utils.ChooserRequestTracker;

	public class BaseCRUDDialogCode extends BaseDialog
	{
		[Bindable]
		protected var choices:Object = new Object();
		[Bindable]
		public var submit:Button;
		protected var _validators:Array;
		protected var chooserRequestTracker:ChooserRequestTracker;
		
		/*	We keep track of which controls have been changed by the user. Upon
		receiving data through the populate() method, those controls which
		have local changes will not be updated. */
		protected var changedControls:Array = [];
		
		public function BaseCRUDDialogCode()
		{
			super();
			chooserRequestTracker = new ChooserRequestTracker();
		}
		
		public function get validators():Array
		{
			return _validators;
		}
		
		public function set validators(data:Array):void
		{
			_validators = data;
		}
		
		public function setChoices(choices:Object):void
		{
			this.choices = choices;
		}
		
		/*  Called when a "Chooser" dialog is used to make a selection,
			such as when choosing an organization for an event. */
		public function receiveChoice(choice:ChooserResult, chooserName:String):void
		{}
		
		protected function updateControlIfUnchanged(control:Object, propertyName:String, newValue:Object):void
		{
			if (!control.hasOwnProperty(propertyName))
				trace('Editable control does not have property ' + propertyName + '!');
				
			else if (changedControls.indexOf(control) == -1)
				control[propertyName] = newValue;
		}
		
		protected function addControlChangeListener(form:Form):void
		{
			if (form == null)
				return;
			
			/* listen for which controls get local changes */
			var formItem:FormItem;
			for each (var child:Object in form.getChildren())
			{
				formItem = child as FormItem;
				if (formItem != null)
					for each (var control:Object in formItem.getChildren())
						control.addEventListener(Event.CHANGE, onControlChanged);
			}
		}
		
		/*	Add a changed control to the list of changed controls */
		protected function onControlChanged(event:Event):void
		{
			changedControls.push(event.target);
		}
		
		protected function onValidatedSubmit(event:Event):void
		{
			if (Validator.validateAll(validators).length == 0)
				dispatchEvent(new ViewEvent(ViewEvent.SUBMIT, getData()));
		}
		
		// Override this
		public function getData():Object
		{
			return null;
		}
		
		public function clear():void
		{
			changedControls = [];
		}
	}
}