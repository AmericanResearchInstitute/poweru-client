package net.poweru.components.dialogs.code
{
	import flash.events.Event;
	
	import mx.controls.Button;
	
	import net.poweru.components.dialogs.BaseDialog;
	import net.poweru.components.interfaces.IResetPassword;
	import net.poweru.generated.interfaces.IGeneratedTextInput;

	public class ResetPasswordCode extends BaseDialog implements IResetPassword
	{
		public var username:IGeneratedTextInput;
		public var email:IGeneratedTextInput;
		public var validators:Array;
		[Bindable]
		public var submit:Button;
		
		public function ResetPasswordCode()
		{
			super();
		}
		
		public function populate(username:String):void
		{
			this.username.text = username;
		}
		
		public function clear():void
		{
			populate('');
		}
		
		protected function onCreationComplete(event:Event):void
		{
			validators = [username.validator, email.validator];
		}
	}
}