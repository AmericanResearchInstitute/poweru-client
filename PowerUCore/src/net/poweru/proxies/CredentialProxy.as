package net.poweru.proxies
{
	import mx.utils.UIDUtil;
	
	import net.poweru.NotificationNames;
	import net.poweru.delegates.CredentialManagerDelegate;
	
	import org.puremvc.as3.interfaces.IProxy;
	
	public class CredentialProxy extends BaseProxy implements IProxy
	{
		public static const NAME:String = 'CredentialProxy';
		public static const FIELDS:Array = ['user', 'credential_type', 'date_expires', 'status'];
		
		public function CredentialProxy()
		{
			super(NAME, CredentialManagerDelegate, NotificationNames.UPDATECREDENTIALS, FIELDS, 'Credential');
			createArgNamesInOrder = ['user', 'credential_type'];
			createOptionalArgNames = ['date_expires', 'status'];
			dateTimeFields = ['date_expires'];
			getFilteredMethodName = 'detail_view';
		}
	}
}