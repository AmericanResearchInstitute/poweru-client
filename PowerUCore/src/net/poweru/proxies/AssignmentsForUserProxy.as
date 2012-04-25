package net.poweru.proxies
{
	import net.poweru.NotificationNames;
	import net.poweru.delegates.AssignmentManagerDelegate;
	
	import org.puremvc.as3.interfaces.IProxy;
	
	public class AssignmentsForUserProxy extends BaseProxy implements IProxy
	{
		public static const NAME:String = 'AssignmentsForUser';
		public static const FIELDS:Array = ['user', 'status', 'task', 'prerequisites_met'];
		
		public function AssignmentsForUserProxy()
		{
			super(NAME, AssignmentManagerDelegate, NotificationNames.UPDATEASSIGNMENTSFORUSER, FIELDS);
			init();
		}
		
		private function init():void
		{
			getFilteredMethodName = 'view';
		}
		
		public function getByUserAndCurriculumEnrollment(curriculumEnrollmentID:Number):void
		{
			getFiltered({'exact':
				{'curriculum_enrollment':curriculumEnrollmentID,
				'user':loginProxy.userPK}
			});
		}
	}
}