package net.poweru.presenters
{
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.proxies.CurriculumProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class EditCurriculumMediator extends BaseEditDialogMediator implements IMediator
	{
		public static const NAME:String = 'EditCurriculumMediator';
		
		public function EditCurriculumMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, CurriculumProxy, Places.EDITCURRICULUM);
		}

	}
}