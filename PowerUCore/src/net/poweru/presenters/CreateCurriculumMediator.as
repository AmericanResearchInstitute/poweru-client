package net.poweru.presenters
{
	import net.poweru.proxies.CurriculumProxy;
	
	import org.puremvc.as3.interfaces.IMediator;

	public class CreateCurriculumMediator extends BaseCreateDialogMediator implements IMediator
	{
		public static const NAME:String = 'CreateCurriculumMediator';
		
		public function CreateCurriculumMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, CurriculumProxy);
		}
	}
}