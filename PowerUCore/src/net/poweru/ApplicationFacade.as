package net.poweru
{
	import mx.core.Container;
	
	import net.poweru.commands.ExamSessionFinishedCommand;
	import net.poweru.commands.LoginContextChosenCommand;
	import net.poweru.commands.SendEmailErrorCommand;
	import net.poweru.commands.SendEmailSuccessCommand;
	
	import org.puremvc.as3.interfaces.IFacade;
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.facade.Facade;

	public class ApplicationFacade extends Facade implements IFacade
	{
		// Useful for when we want to clear proxies
		protected var _proxyNames:Array = [];
		
		public static function getInstance():ApplicationFacade
		{
			if (instance == null)
				instance = new ApplicationFacade();
			return instance as ApplicationFacade;
		}
		
		override public function registerProxy(proxy:IProxy):void
		{
			super.registerProxy(proxy);
			_proxyNames.push(proxy.getProxyName());
		}
		
		public function get proxyNames():Array
		{
			return _proxyNames;
		}
		
		// Retrieves a proxy. If that proxy hasn't been registered previously,
		// this takes care of it for you.
		public function retrieveOrRegisterProxy(proxyClass:Class):IProxy
		{
			var proxy:IProxy = retrieveProxy(proxyClass.NAME);
			if (proxy == null)
			{
				proxy = new proxyClass();
				registerProxy(proxy);
			}
			return proxy;
		}
		
		public function startup(stage:Container):void
		{
			sendNotification(NotificationNames.STARTUP, stage);
		}
		
		override protected function initializeController():void
		{
			super.initializeController();
			
			registerCommand(NotificationNames.EXAMSESSIONFINISHED, ExamSessionFinishedCommand);
			registerCommand(NotificationNames.EMAILSENT, SendEmailSuccessCommand);
			registerCommand(NotificationNames.EMAILSENDERROR, SendEmailErrorCommand);
			registerCommand(NotificationNames.CHOICEMADE, LoginContextChosenCommand);
		}
		
	}
}