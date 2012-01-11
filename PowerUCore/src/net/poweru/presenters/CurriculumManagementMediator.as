package net.poweru.presenters
{
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class CurriculumManagementMediator extends BasePlaceContainerMediator implements IMediator
	{
		public static const NAME:String = 'CurriculumManagementMediator';
		
		public function CurriculumManagementMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
		}
	}
}