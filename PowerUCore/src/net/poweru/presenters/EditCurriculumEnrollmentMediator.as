package net.poweru.presenters
{
	import net.poweru.Places;
	import net.poweru.proxies.CurriculumEnrollmentUserDetailProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	
	public class EditCurriculumEnrollmentMediator extends BaseEditDialogMediator implements IMediator
	{
		public static const NAME:String = 'EditCurriculumEnrollmentMediator';
		
		public function EditCurriculumEnrollmentMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, CurriculumEnrollmentUserDetailProxy, Places.EDITCURRICULUMENROLLMENT);
		}
	}
}