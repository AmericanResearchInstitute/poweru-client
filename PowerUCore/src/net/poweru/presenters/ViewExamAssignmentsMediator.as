package net.poweru.presenters
{
	import net.poweru.proxies.ExamAssignmentsByTaskProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	
	public class ViewExamAssignmentsMediator extends BaseReportDialogMediator implements IMediator
	{
		public static const NAME:String = 'ViewExamAssignmentsMediator';
		
		public function ViewExamAssignmentsMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, ExamAssignmentsByTaskProxy);
		}
	}
}