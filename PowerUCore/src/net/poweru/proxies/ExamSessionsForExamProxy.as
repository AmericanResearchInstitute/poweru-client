package net.poweru.proxies
{
	import net.poweru.NotificationNames;
	import net.poweru.delegates.ExamSessionManagerDelegate;
	
	import org.puremvc.as3.interfaces.IProxy;
	
	public class ExamSessionsForExamProxy extends BaseCollectionCachingProxy implements IProxy
	{
		public static const NAME:String = 'ExamSessionsForExamProxy';
		public static const FIELDS:Array = ['date_completed', 'number_correct', 'passed', 'passing_score', 'score'];
		
		public function ExamSessionsForExamProxy()
		{
			super(NAME, ExamSessionManagerDelegate, NotificationNames.UPDATEEXAMSESSIONSFOREXAM, FIELDS, 'exam', 'ExamSession');
			dateTimeFields = ['date_completed'];
		}
	}
}