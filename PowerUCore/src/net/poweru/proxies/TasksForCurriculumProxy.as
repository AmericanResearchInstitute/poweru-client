package net.poweru.proxies
{
	import net.poweru.NotificationNames;
	import net.poweru.delegates.TaskManagerDelegate;
	
	import org.puremvc.as3.interfaces.IProxy;
	
	public class TasksForCurriculumProxy extends BaseCollectionCachingProxy implements IProxy
	{
		public static const NAME:String = 'TasksForCurriculumProxy';
		public static const FIELDS:Array = ['name', 'title', 'description', 'type'];
		
		public function TasksForCurriculumProxy()
		{
			super(NAME, TaskManagerDelegate, NotificationNames.UPDATETASKSFORCURRICULUM, FIELDS, 'curriculums', 'Task');
		}
	}
}