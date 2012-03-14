package net.poweru.components.dialogs.code
{
	import mx.controls.DateField;
	
	import net.poweru.components.dialogs.BaseCRUDDialog;
	import net.poweru.components.interfaces.ICreateCurriculumEnrollment;
	
	public class CreateCurriculumEnrollmentCode extends BaseCRUDDialog implements ICreateCurriculumEnrollment
	{
		[Bindable]
		protected var curriculum:Object;
		
		public var startDate:DateField;
		public var endDate:DateField;
		
		public function CreateCurriculumEnrollmentCode()
		{
			super();
			validators = [];
		}
		
		override public function clear():void
		{
			curriculum = {};
			startDate.selectedDate = null;
			endDate.selectedDate = null;
		}
		
		public function populate(curriculum:Object):void
		{
			clear();
			this.curriculum = curriculum;
		}
		
		override public function getData():Object
		{
			return {
				'curriculum' : curriculum.id,
				'start' : startDate.selectedDate,
				'end' : endDate.selectedDate
			}
		}
	}
}