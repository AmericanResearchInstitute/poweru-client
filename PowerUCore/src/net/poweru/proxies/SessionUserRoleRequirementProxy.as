package net.poweru.proxies
{
	import net.poweru.NotificationNames;
	import net.poweru.delegates.SessionUserRoleRequirementManagerDelegate;
	
	import org.puremvc.as3.interfaces.IProxy;
	
	public class SessionUserRoleRequirementProxy extends BaseProxy implements IProxy
	{
		public static const NAME:String = 'SessionUserRoleRequirementProxy';
		
		public function SessionUserRoleRequirementProxy()
		{
			super(NAME, SessionUserRoleRequirementManagerDelegate, NotificationNames.UPDATESESSIONUSERROLEREQUIREMENTS, [], 'SessionUserRoleRequirement');
			createArgNamesInOrder = ['session', 'session_user_role', 'min', 'max'];
		}
	}
}