package net.poweru.proxies
{
	import mx.rpc.events.ResultEvent;
	
	import net.poweru.NotificationNames;
	import net.poweru.delegates.CurriculumEnrollmentManagerDelegate;
	import net.poweru.model.DataSet;
	import net.poweru.utils.PowerUResponder;

	public class CurriculumEnrollmentProxy extends BaseProxy
	{
		public static const NAME:String = 'CurriculumEnrollmentProxy';
		public static const FIELDS:Array = ['curriculum_name', 'start', 'end'];
		
		public function CurriculumEnrollmentProxy()
		{
			super(NAME, CurriculumEnrollmentManagerDelegate, NotificationNames.UPDATECURRICULUMENROLLMENTS, FIELDS);
			dateTimeFields = ['start', 'end'];
			createArgNamesInOrder = ['curriculum', 'start', 'end'];
		}
		
		public function getStudentCurriculumEnrollments():void
		{
			getFiltered({'exact' : {'users__id' : loginProxy.userPK}});
		}
	}
}