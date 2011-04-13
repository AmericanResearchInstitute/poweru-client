package net.poweru.components.parts.code
{
	import net.poweru.model.DataSet;

	import mx.binding.utils.BindingUtils;
	import mx.collections.ArrayCollection;
	import mx.containers.HBox;
	import mx.controls.Button;
	import mx.controls.ComboBox;
	import mx.controls.TextInput;
	import mx.events.StateChangeEvent;

	public class AddEmailDomainCode extends HBox
	{
		[Bindable]
		public var orgRoleData:DataSet;

		public var emailDomainTI:TextInput;
		public var orgRoleCB:ComboBox;
		public var confirm:Button;
		
		public var orgEmailDomainDataSet:DataSet;
		
		public function AddEmailDomainCode()
		{
			super();
			orgRoleData = new DataSet();
			orgRoleData.filterFunction = filterRoles;
			addEventListener(StateChangeEvent.CURRENT_STATE_CHANGE, onCurrentStateChange);
		}

		protected function onCurrentStateChange(event:StateChangeEvent):void
		{
			if (event.newState == 'adding')
			{
				emailDomainTI.text = null;
				orgRoleData.refresh();
			}
		}

		public function get emailDomain():String
		{
			return emailDomainTI.text;
		}

		public function get selectedOrgRole():Object
		{
			return orgRoleCB.selectedItem;
		}
		
		protected function filterRoles(item:Object):Boolean
		{
			if (orgEmailDomainDataSet == null || emailDomainTI == null)
			{
				return false;
			}
			for each (var orgEmailDomain:Object in orgEmailDomainDataSet)
			{
				if (orgEmailDomain['role'] != item['id'] && orgEmailDomain['effective_role'] != item['id'])
				{
					continue;
				}
				if (orgEmailDomain['email_domain'] == emailDomainTI.text)
				{
					return false;
				}
			}
			return true;
		}
	}
}