package net.poweru.delegates
{
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;

	public class OrganizationManagerDelegate extends BaseDelegate
	{	
		public function OrganizationManagerDelegate(responder:IResponder)
		{
			super(responder, 'OrganizationManager', ['children', 'user_org_roles', 'org_email_domains']);
			mangleMap = {'parent' : mangleForeignKey};
		}
		
		public function adminOrganizationsView(authToken:String):void
		{
			var token:AsyncToken = remoteObject.getOperation('admin_org_view').send(authToken);
			token.addResponder(responder);
		}
		
		public function adminOrganizationUsersView(authToken:String, org:Number):void
		{
			var token:AsyncToken = remoteObject.getOperation('admin_org_user_view').send(authToken, org);
			token['org'] = org;
			token.addResponder(responder);
		}
	}
}