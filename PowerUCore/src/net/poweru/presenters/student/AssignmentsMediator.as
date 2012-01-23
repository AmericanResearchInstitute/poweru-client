package net.poweru.presenters.student
{
	import net.poweru.presenters.BasePlaceContainerMediator;
	
	import org.puremvc.as3.interfaces.IMediator;
	
	public class AssignmentsMediator extends BasePlaceContainerMediator implements IMediator
	{
		public static const NAME:String = 'StudentAssignmentsMediator';
		
		public function AssignmentsMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
		}
	}
}