package net.poweru.proxies
{
	import net.poweru.NotificationNames;
	import net.poweru.delegates.SessionManagerDelegate;
	
	import org.puremvc.as3.interfaces.IProxy;
	
	public class OrgEnrolledSessionProxy extends BaseProxy implements IProxy
	{
		public static const NAME:String = 'OrgEnrolledSessionProxy';
		
		public function OrgEnrolledSessionProxy()
		{
			super(NAME, SessionManagerDelegate, NotificationNames.UPDATEORGENROLLEDSESSIONS, [], 'Session');
			init();
		}
		
		private function init():void
		{
			createArgNamesInOrder = ['start', 'end', 'status', 'confirmed', 'default_price', 'event', 'shortname', 'fullname'];
			createOptionalArgNames = ['title', 'url', 'description', 'lead_time'];
			dateTimeFields = ['start', 'end'];
			getFilteredMethodName = 'detailed_surr_view';
		}
		
		override public function getFiltered(filters:Object, uid:String=null):void
		{
			if (loginProxy.associatedOrgs != null && loginProxy.associatedOrgs.length > 0)
			{
				if (!filters.hasOwnProperty('member'))
					filters['member'] = {};
				filters['member']['session_user_role_requirements__users__organizations__id'] = loginProxy.associatedOrgs;
			}
			else
			{
				if (!filters.hasOwnProperty('isnull'))
					filters['isnull'] = {};
				filters['isnull']['session_user_role_requirements__users'] = false;
			}
			return super.getFiltered(filters, uid);
		}
	}
}