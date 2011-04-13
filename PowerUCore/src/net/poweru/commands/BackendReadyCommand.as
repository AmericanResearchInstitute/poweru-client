package net.poweru.commands
{
	import net.poweru.ApplicationFacade;
	import net.poweru.proxies.LoginProxy;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	// When the space is ready, what should be presented first?  This command gets to decide.
	public class BackendReadyCommand extends SimpleCommand implements ICommand
	{
		override public function execute(notification:INotification):void
		{
			// 	The following command will attempt to continue a pre-existing auth session. If that is not possible,
			//	it will set the space to Places.LOGIN.
			var loginProxy:LoginProxy = (facade as ApplicationFacade).retrieveOrRegisterProxy(LoginProxy) as LoginProxy;
			loginProxy.attemptRelogin();
		}
		
	}
}