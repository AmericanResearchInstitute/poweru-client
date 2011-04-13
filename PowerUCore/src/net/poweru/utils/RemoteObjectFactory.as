package net.poweru.utils
{
	import net.poweru.ApplicationFacade;
	import net.poweru.proxies.BrowserServicesProxy;
	
	import mx.messaging.ChannelSet;
	import mx.messaging.channels.AMFChannel;
	import mx.messaging.channels.SecureAMFChannel;
	import mx.rpc.remoting.RemoteObject;
	
	public class RemoteObjectFactory
	{
		private static var instance:RemoteObjectFactory;
		protected var channelSet:ChannelSet;
		
		public function RemoteObjectFactory()
		{
			channelSet = new ChannelSet();
			var browserServicesProxy:BrowserServicesProxy = ApplicationFacade.getInstance().retrieveOrRegisterProxy(BrowserServicesProxy) as BrowserServicesProxy;
			
			if (browserServicesProxy.usingSSL)
				channelSet.addChannel(new SecureAMFChannel('secure', browserServicesProxy.rpcURL));
			else
				channelSet.addChannel(new AMFChannel('insecure', browserServicesProxy.rpcURL));
		}
		
		public static function getInstance():RemoteObjectFactory
		{
			if (instance == null)
				instance = new RemoteObjectFactory();
			return instance;
		}
		
		public function getRemoteObject(destination:String):RemoteObject
		{
			var ro:RemoteObject = new RemoteObject(destination);
			ro.channelSet = channelSet;
			return ro;
		}

	}
}