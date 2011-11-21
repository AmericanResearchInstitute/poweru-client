package net.poweru.delegates
{
	import mx.rpc.IResponder;

	public class UserOrgRoleManagerDelegate extends BaseDelegate
	{
		public function UserOrgRoleManagerDelegate(responder:IResponder)
		{
			super(responder, 'UserOrgRoleManager');
			getFilteredMethodName = 'user_org_role_detail_view';
		}
		
	}
}