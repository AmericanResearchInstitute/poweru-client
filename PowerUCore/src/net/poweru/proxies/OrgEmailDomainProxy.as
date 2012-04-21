package net.poweru.proxies
{
	import mx.rpc.events.ResultEvent;
	
	import net.poweru.NotificationNames;
	import net.poweru.delegates.OrgEmailDomainManagerDelegate;
	import net.poweru.utils.PowerUResponder;
	
	import org.puremvc.as3.interfaces.IProxy;

	public class OrgEmailDomainProxy extends BaseProxy implements IProxy
	{
		public static const NAME:String = 'OrgEmailDomainProxy';
		
		public function OrgEmailDomainProxy()
		{
			super(NAME, OrgEmailDomainManagerDelegate, NotificationNames.UPDATEORGEMAILDOMAINS, []);
			init();
		}
		
		private function init():void
		{
			createArgNamesInOrder = ['email_domain', 'organization', 'role'];
		}

		override public function deleteObject(pk:Number):void
		{
			new OrgEmailDomainManagerDelegate(new PowerUResponder(onDeleteSuccess, onDeleteError, onFault)).deleteObject(loginProxy.authToken, pk);
		}
		
		override protected function onDeleteSuccess(data:ResultEvent):void
		{
			sendNotification(updatedDataNotification);
		}
	}
}