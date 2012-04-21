package net.poweru.proxies
{
	import net.poweru.NotificationNames;
	import net.poweru.delegates.CurriculumEnrollmentManagerDelegate;
	
	import org.puremvc.as3.interfaces.IProxy;
	
	public class CurriculumEnrollmentUserDetailProxy extends BaseProxy implements IProxy
	{
		public static const NAME:String = 'CurriculumEnrollmentUserDetailProxy';
		
		public function CurriculumEnrollmentUserDetailProxy()
		{
			super(NAME, CurriculumEnrollmentManagerDelegate, NotificationNames.UPDATECURRICULUMENROLLMENTSUSERDETAIL, [], 'CurriculumEnrollment');
			init();
		}
		
		private function init():void
		{
			getFilteredMethodName = 'user_detail_view';
			dateTimeFields = ['start', 'end'];
			createArgNamesInOrder = ['curriculum', 'start', 'end'];
		}
	}
}