package net.poweru.commands
{
	import net.poweru.ApplicationFacade;
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.model.ChooserResult;
	import net.poweru.proxies.LoginProxy;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class LoginContextChosenCommand extends SimpleCommand implements ICommand
	{
		protected var loginProxy:LoginProxy;
		
		public function LoginContextChosenCommand()
		{
			super();
			loginProxy = (facade as ApplicationFacade).retrieveOrRegisterProxy(LoginProxy) as LoginProxy;
		}
		
		override public function execute(notification:INotification):void
		{
			if (notification.getType() == Places.CHOOSELOGINCONTEXT)
			{
				var result:ChooserResult = notification.getBody() as ChooserResult;
				loginProxy.activeUserOrgRole = result.value;
				loginProxy.sendLoginSuccess();
			}
		}
	}
}