package net.poweru.components.parts.code
{
	import net.poweru.model.DataSet;
	
	import flash.events.Event;
	
	import mx.containers.HBox;
	import mx.controls.Button;
	import mx.controls.ComboBox;

	public class AddOrganizationCode extends HBox
	{
		[Bindable]
		public var organizationData:DataSet;
		[Bindable]
		public var orgRoleData:DataSet;
		// existing relationships
		public var orgDataSet:DataSet;
		public var organizationCB:ComboBox;
		public var orgRoleCB:ComboBox;
		
		public var confirm:Button;
		
		public function AddOrganizationCode()
		{
			super();
			organizationData = new DataSet();
			orgRoleData = new DataSet();
			orgRoleData.filterFunction = filterRoles;
		}
		
		public function get selectedOrganization():Object
		{
			return organizationCB.selectedItem;
		}
		
		public function get selectedOrgRole():Object
		{
			return orgRoleCB.selectedItem;
		}
		
		protected function filterRoles(item:Object):Boolean
		{
			if (organizationCB == null || orgDataSet == null)
				return false
				
			var userOrgRoles:DataSet = orgDataSet.findMembersByKey('role', [item['id']]);
			for each (var userOrgRole:Object in userOrgRoles)
				if (userOrgRole['organization'] == organizationCB.selectedItem['id'])
					return false
			return true;
		}
		
		protected function onCBCreationComplete(event:Event):void
		{
			orgRoleData.refresh();
		}
		
	}
}