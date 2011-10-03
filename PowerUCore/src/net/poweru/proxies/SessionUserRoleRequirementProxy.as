package net.poweru.proxies
{
	import net.poweru.NotificationNames;
	import net.poweru.delegates.SessionUserRoleRequirementManagerDelegate;
	
	import org.puremvc.as3.interfaces.IProxy;
	
	public class SessionUserRoleRequirementProxy extends BaseProxy implements IProxy
	{
		public static const NAME:String = 'SessionUserRoleRequirementProxy';
		public static const FIELDS:Array = ['session', 'session_user_role', 'max', 'min', 'credential_types'];
		
		public function SessionUserRoleRequirementProxy(proxyName:String, primaryDelegateClass:Class, updatedDataNotification:String, fields:Array, modelName:String=null, choiceFields:Array=null)
		{
			super(NAME, SessionUserRoleRequirementManagerDelegate, NotificationNames.UPDATESESSIONUSERROLEREQUIREMENTS, FIELDS, 'SessionUserRoleRequirement');
		}
	}
}