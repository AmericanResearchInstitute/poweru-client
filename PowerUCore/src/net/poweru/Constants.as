package net.poweru
{
	public class Constants
	{
		public static const THUMBNAILHEIGHT:int = 90;
		public static const THUMBNAILWIDTH:int = 160;
		
		// In something like a combobox, these default values may be needed
		public static const ALL:String = 'All';
		public static const NONE:String = 'None';
		
		/*	This field can be added to an object with any value to signify that
			the object is not editable. This is useful for a proxy to make the
			decision about what the user has permission to edit, and then the
			views can use the presense of this attribute name to disable editing.
		*/
		public static const NOT_EDITABLE_FIELD_NAME:String = '__not_editable__';
		
		public static const HONORIFICS:Array = [
			'Dr.',
			'Mr.',
			'Ms.',
			'Mrs.',
			'Miss',
		];
		
		public static const BULKASSIGN:String = 'BulkAssign';
		public static const CREDENTIAL:String = 'Credential';
		public static const CURRICULUMENROLLMENT:String = 'CurriculumEnrollment';
		public static const SENDEMAIL:String = 'SendEmail';
		
		// Exam widget types
		public static const RADIOSELECT:String = 'RadioSelect';
		public static const CHECKBOXSELECTMULTIPLE:String = 'CheckboxSelectMultiple';
		
		public static const TASK_FEE:String = 'TaskFee';
		
		// Organization Role Names
		public static const OWNER_MANAGER:String = 'Owner Manager';
		public static const ORG_ADMIN:String = 'Administrator';
		public static const SERV_DEALER_ADMIN:String = 'Serv Dealer Admin';
		public static const ADMIN_ASSISTANT:String = 'Admin Assistant';
		
		/*	Statuses of assignments that mean it's incomplete but still
			eligible to be completed. */
		public static const ASSIGNMENT_INCOMPLETE_STATUSES:Array = [
			'assigned',
			'late',
			'pending',
			'unpaid',
			'wait-listed'
		];
		
		public static const ACTIVE_CHECKBOX_TOOLTIP:String = 'If unchecked, this entry will no longer be available to users and will only appear in historical contexts, such as on a transcript.'
	}
}