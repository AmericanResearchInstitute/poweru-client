package net.poweru.proxies
{
	import net.poweru.NotificationNames;
	import net.poweru.delegates.CredentialTypeManagerDelegate;
	
	import org.puremvc.as3.interfaces.IProxy;
	
	public class CredentialTypeProxy extends BaseProxy implements IProxy
	{
		public static const NAME:String = 'CredentialTypeProxy';
		public static const FIELDS:Array = [
			'name',
			'description',
			'duration',
			'required_achievements'
		];
		
		public function CredentialTypeProxy()
		{
			super(NAME, CredentialTypeManagerDelegate, NotificationNames.UPDATECREDENTIALTYPES, FIELDS, 'CredentialType', []);
			createArgNamesInOrder = ['name', 'description'];
			getFilteredMethodName = 'achievement_detail_view';
		}
	}
}