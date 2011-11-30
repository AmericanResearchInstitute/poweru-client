package net.poweru.components.dialogs.code
{
	import flash.events.Event;
	
	import mx.controls.Alert;
	import mx.controls.TextArea;
	import mx.managers.PopUpManager;
	
	import net.poweru.components.dialogs.BaseDialog;
	
	public class EmailSessionParticipantsCode extends BaseDialog
	{
		public var messageInput:TextArea;
		
		public function EmailSessionParticipantsCode()
		{
			super();
		}
		
		public function clear():void
		{
			messageInput.text = '';
		}
		
		protected function onSubmit(event:Event):void
		{
			Alert.show('Message sent');
			PopUpManager.removePopUp(this);
			clear();
		}
	}
}