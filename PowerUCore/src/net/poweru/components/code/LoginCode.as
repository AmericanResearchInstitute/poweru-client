package net.poweru.components.code
{
	import mx.containers.VBox;
	import mx.controls.Button;
	import mx.controls.TextInput;
	import mx.events.FlexEvent;
	
	import net.poweru.components.interfaces.ILogin;

	public class LoginCode extends VBox implements ILogin
	{
		public var username:TextInput;
		public var password:TextInput;
		[Bindable]
		public var submit:Button;
		
		public function LoginCode()
		{
			super();
		}
		
		public function getCredentials():Array
		{
			return [username.text, password.text];
		}
		
		public function clearPassword():void
		{
			password.text = '';
		}
		
		public function setControlEnabledness(enabled:Boolean):void
		{
			submit.enabled = enabled;
			username.enabled = enabled;
			password.enabled = enabled;
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			focusManager.setFocus(username);
		}
		
	}
}