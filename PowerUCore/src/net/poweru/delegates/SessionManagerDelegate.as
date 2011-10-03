package net.poweru.delegates
{
	import mx.rpc.IResponder;
	
	public class SessionManagerDelegate extends BaseDelegate
	{
		protected static const SPECIALUPDATEHANDLINGINFO:Object = {
			'session_user_role_requirements' : {
				'attribute_to_update' : 'session_user_roles',
				'foreign_attribute_name' : 'session_user_role',
				'attributes_to_include' : ['min', 'max']
			}
		}
			
		public function SessionManagerDelegate(responder:IResponder)
		{
			super(responder, 'SessionManager', [], SPECIALUPDATEHANDLINGINFO);
			mangleMap = {
				'start' : mangleDate,
				'end' : mangleDate
			};
			getFilteredMethodName = 'detailed_surr_view';
		}
	}
}