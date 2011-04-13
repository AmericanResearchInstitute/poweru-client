package net.poweru.components.dialogs.code
{
	import net.poweru.components.dialogs.BaseDialog;
	import net.poweru.events.ViewEvent;
	
	import flash.events.Event;
	
	import mx.controls.Button;
	import mx.validators.Validator;

	public class BaseCRUDDialogCode extends BaseDialog
	{
		[Bindable]
		protected var choices:Object = new Object();
		[Bindable]
		public var submit:Button;
		public var validators:Array;
		
		public function BaseCRUDDialogCode()
		{
			super();
		}
		
		public function setChoices(choices:Object):void
		{
			this.choices = choices;
		}
		
		public function setState(state:String):void
		{
			/* 	Not a big deal for us if the state isn't found. Also, sometimes
			 	when we call IEditDialog.setState(), the states defined on the
				subclass are not detected, resulting in this error.  I don't
				know why. */
			try
			{
				currentState = state;
			}
			catch (err:ArgumentError)
			{
				trace(err.message);
			}
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
	}
}