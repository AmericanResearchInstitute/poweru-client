package net.poweru.components.dialogs.code
{
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	
	import mx.containers.VBox;
	import mx.controls.Button;
	import mx.controls.Text;
	import mx.core.Container;
	import mx.events.ChildExistenceChangedEvent;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	
	import net.poweru.Places;
	import net.poweru.components.dialogs.BaseDialog;
	import net.poweru.components.dialogs.CreateEvent;
	import net.poweru.components.dialogs.CreateSession;
	import net.poweru.components.dialogs.EditSession;
	import net.poweru.components.interfaces.ICreateEventWizard;
	import net.poweru.events.ViewEvent;
	
	public class CreateEventWizardCode extends BaseDialog implements ICreateEventWizard
	{
		protected static const HELP_BEGIN:String = 'This wizard will guide you through the process of creating an event with sessions.';
		
		protected static const HELP_CREATE_EVENT:String = 'Complete the form as shown. Hit "Submit" when done, or click the X at the top-right to close the wizard at any time.';
			
		protected static const HELP_CREATE_SESSION:String = 'Complete the form as shown. Hit "Submit" when done, or click the X at the top-right to close the wizard at any time. ' +
			'After you submit the form, you will be able to choose a venue and define enrollment numbers.';
		
		protected static const HELP_EDIT_SESSION:String = 'Complete the form as shown. Hit "Submit" when done, or click the X at the top-right to close the wizard at any time. ' +
			'To choose a room, click "Choose Venue/Room". Select a venue on the left side of the new dialog, and then select one of its rooms on the right side. ' +
			'To define enrollment numbers, click "Add Role".';
		
		[Bindable]
		public var dialogSpace:VBox;
		public var beginButton:Button;
		public var helpText:Text;
		
		protected var pendingNextPlaceName:String;
		protected var eventID:Number;
		
		public function CreateEventWizardCode()
		{
			super();
			init();
		}
		
		private function init():void
		{
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		public function setEventID(eventID:Number):void
		{
			if (pendingNextPlaceName == Places.CREATESESSION)
			{
				this.eventID = eventID;
				dispatchEvent(new ViewEvent(ViewEvent.FETCH, [dialogSpace, eventID], pendingNextPlaceName));
				pendingNextPlaceName = '';
			}
		}
		
		public function setSessionID(sessionID:Number):void
		{
			if (pendingNextPlaceName == Places.EDITSESSION)
			{
				dispatchEvent(new ViewEvent(ViewEvent.FETCH, [dialogSpace, sessionID], pendingNextPlaceName));
				pendingNextPlaceName = '';
			}
		}
		
		public function reset():void
		{
			if (dialogSpace.getChildren().length == 1 && dialogSpace.getChildAt(0) is BaseDialog)
			{
				var dialog:BaseDialog = dialogSpace.getChildAt(0) as BaseDialog;
				dialog.showCloseButton = true;
				findCancelButtonAndSetVisibility(dialog, true);
				pendingNextPlaceName = '';
			}
			dialogSpace.removeAllChildren();
			dialogSpace.addChild(beginButton);
			eventID = -1;
		}
		
		//	returns the name of the next place that should be displayed
		protected function getNextPlaceName(currentChild:BaseDialog):String
		{
			var ret:String = '';
			if (currentChild is CreateEvent)
				ret = Places.CREATESESSION;
			else if (currentChild is CreateSession)
				ret = Places.EDITSESSION;
			else if (currentChild is EditSession)
				ret = Places.CREATESESSION;
			return ret;
		}
		
		/*	makes a best effort to find a cancel button and then sets its
			'visible' and 'includeInLayout' attributes to the 'visible' value
			passed in here.	This function is recursive. */
		protected function findCancelButtonAndSetVisibility(container:Container, visible:Boolean=true):void
		{
			var dialog:BaseDialog = container as BaseDialog;
			if (dialog != null && dialog.creationIsComplete == false)
			{
				dialog.addEventListener(FlexEvent.CREATION_COMPLETE, onChildCreationComplete);
			}
			else
			{
				var children:Array = container.getChildren();
				for each (var child:Object in children)
				{
					if (child is Button)
					{
						var button:Button = child as Button;
						if (button.label == 'Cancel')
						{
							button.visible = visible;
							button.includeInLayout = visible;
						}
					}
					else if (child is Container)
					{
						findCancelButtonAndSetVisibility(child as Container, visible);
					}
				}
			}
		}
		
		protected function rotateHelpText(newChild:Object):void
		{
			if (newChild is Button)
				helpText.text = HELP_BEGIN;
			else if (newChild is CreateEvent)
				helpText.text = HELP_CREATE_EVENT;
			else if (newChild is CreateSession)
				helpText.text = HELP_CREATE_SESSION;
			else if (newChild is EditSession)
				helpText.text = HELP_EDIT_SESSION;
			else
				helpText.text = '';
		}
		
		protected function onChildCreationComplete(event:FlexEvent):void
		{
			(event.target as IEventDispatcher).removeEventListener(FlexEvent.CREATION_COMPLETE, onChildCreationComplete);
			findCancelButtonAndSetVisibility(event.target as Container, false);
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			beginButton.addEventListener(MouseEvent.CLICK, onBegin);
			dialogSpace.addEventListener(ChildExistenceChangedEvent.CHILD_ADD, onChildAdded);
			
			helpText.setStyle("textField.wordWrap","textField.wordWrap");
		}
		
		protected function onChildAdded(event:ChildExistenceChangedEvent):void
		{
			var dialog:BaseDialog = dialogSpace.getChildAt(0) as BaseDialog;
			if (dialog != null)
			{
				dialog.showCloseButton = false;
				findCancelButtonAndSetVisibility(dialog, false);
				dialog.addEventListener(ViewEvent.SUBMIT, onChildSubmit);
			}
			rotateHelpText(dialogSpace.getChildAt(0));
		}
		
		protected function onChildSubmit(event:ViewEvent):void
		{
			dialogSpace.removeAllChildren();
			
			var dialog:BaseDialog = event.target as BaseDialog;
			dialog.showCloseButton = true;
			findCancelButtonAndSetVisibility(dialog, true);
			pendingNextPlaceName = getNextPlaceName(dialog);
			
			// If we already created and edited a session, it's time to create another
			if (pendingNextPlaceName == Places.CREATESESSION && eventID != -1 && !isNaN(eventID))
			{
				dispatchEvent(new ViewEvent(ViewEvent.FETCH, [dialogSpace, eventID], pendingNextPlaceName));
				pendingNextPlaceName = '';
			}
		}
		
		/*	sends the event ID if we have one so that the event object can be
			refreshed, thus showing any related sessions. */
		override protected function onClose(event:CloseEvent):void
		{
			dispatchEvent(new ViewEvent(ViewEvent.CANCEL, (eventID != -1 && !isNaN(eventID)) ? eventID : null));
			reset();
		}
		
		protected function onBegin(event:MouseEvent):void
		{
			dialogSpace.removeAllChildren();
			dispatchEvent(new ViewEvent(ViewEvent.SETOTHERSPACE, dialogSpace, Places.CREATEEVENT));
		}
	}
}