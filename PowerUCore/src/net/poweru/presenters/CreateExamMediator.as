package net.poweru.presenters
{
	import net.poweru.proxies.ExamProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	
	public class CreateExamMediator extends BaseCreateDialogMediator implements IMediator
	{
		public static const NAME:String = 'CreateExamMediator';
		
		public function CreateExamMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, ExamProxy);
		}
	}
}