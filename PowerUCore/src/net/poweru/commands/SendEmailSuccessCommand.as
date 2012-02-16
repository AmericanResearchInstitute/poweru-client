package net.poweru.commands
{
	import mx.controls.Alert;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class SendEmailSuccessCommand extends SimpleCommand implements ICommand
	{
		public function SendEmailSuccessCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			Alert.show('Email sent successfully.');
		}
	}
}