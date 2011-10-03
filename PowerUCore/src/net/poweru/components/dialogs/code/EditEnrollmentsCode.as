package net.poweru.components.dialogs.code
{
	import mx.containers.Accordion;
	
	import net.poweru.components.dialogs.BaseCRUDDialog;
	import net.poweru.components.interfaces.IEditDialog;
	import net.poweru.components.parts.SURRAssignments;
	
	public class EditEnrollmentsCode extends BaseCRUDDialog implements IEditDialog
	{
		public var accordion:Accordion;
		
		public function EditEnrollmentsCode()
		{
			super();
		}
		
		public function clear():void
		{
			accordion.removeAllChildren();
		}
		
		public function populate(data:Object, ...args):void
		{
			var assignments:Array = args[0] as Array;
			var surrs:Array = data as Array;
			
			var sortedAssignments:Object = {};
			for each (var surr:Object in surrs)
				sortedAssignments[surr['id']] = [];
			for each (var assignment:Object in assignments)
				(sortedAssignments[assignment['task']] as Array).push(assignment);
				
			for each (var surr2:Object in surrs)
			{
				var surrAssignments:SURRAssignments = new SURRAssignments();
				surrAssignments.surr = surr2;
				surrAssignments.assignments.source = sortedAssignments[surr2['id']];
				surrAssignments.assignments.refresh();
				surrAssignments.label = surr2['role_name'] + ' (' + surrAssignments.assignments.length.toString() + ')';
				accordion.addChild(surrAssignments);
			}
		}
	}
}