package net.poweru.components.dialogs.code
{
	import mx.controls.ComboBox;
	
	import net.poweru.components.dialogs.BaseCRUDDialog;
	import net.poweru.components.interfaces.IEditDialog;
	
	public class EditAssignmentCode extends BaseCRUDDialog implements IEditDialog
	{
		public static const STATUSES:Array = ['assigned','canceled', 'completed', 'pending', 'unpaid', 'withdrawn'];
		
		public var statusInput:ComboBox;
		
		[Bindable]
		protected var assignment:Object;
		
		public function EditAssignmentCode()
		{
			super();
			validators = [];
		}
		
		override public function clear():void
		{
			populate({});
		}
		
		public function populate(data:Object, ...args):void
		{
			assignment = data;
			statusInput.selectedItem = data['status'];
		}
		
		override public function getData():Object
		{
			assignment.status = statusInput.selectedLabel;
			return assignment;
		}
	}
}