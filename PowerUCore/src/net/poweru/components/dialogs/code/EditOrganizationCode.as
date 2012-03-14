package net.poweru.components.dialogs.code
{
	import flash.events.MouseEvent;
	
	import mx.binding.utils.BindingUtils;
	import mx.controls.CheckBox;
	import mx.controls.DataGrid;
	import mx.events.FlexEvent;
	
	import net.poweru.components.dialogs.BaseCRUDDialog;
	import net.poweru.components.interfaces.IEditDialog;
	import net.poweru.components.parts.AddEmailDomain;
	import net.poweru.generated.interfaces.IGeneratedTextInput;
	import net.poweru.generated.model.Organization.ExternalUidInput;
	import net.poweru.model.DataSet;

	public class EditOrganizationCode extends BaseCRUDDialog implements IEditDialog
	{
		public var nameInput:IGeneratedTextInput;

		[Bindable]
		public var orgEmailDomains:DataGrid;
		[Bindable]
		protected var orgEmailDomainDataSet:DataSet;
		[Bindable]
		public var addEmailDomain:AddEmailDomain;
		[Bindable]
		public var externalUIDInput:ExternalUidInput;
		public var externalUIDAutoEnroll:CheckBox;
		
		protected var pk:Number;
		
		public function EditOrganizationCode()
		{
			super();
			orgEmailDomainDataSet = new DataSet();
		}
		
		override public function clear():void
		{
			nameInput.text = '';
			pk = NaN;
			externalUIDInput.text = '';
			externalUIDAutoEnroll.selected = false;

			orgEmailDomainDataSet.source = [];
			orgEmailDomainDataSet.refresh();
		}
		
		override public function getData():Object
		{
			return {
				'name' : nameInput.text,
				'id' : pk,
				'org_email_domains' : orgEmailDomainDataSet.toArray(),
				'external_uid' : externalUIDInput.text,
				'use_external_uid' : externalUIDAutoEnroll.selected
			}
		}
		
		// args[0] is all organization roles
		public function populate(data:Object, ...args):void
		{
			orgEmailDomainDataSet.source = data['org_email_domains'];
			orgEmailDomainDataSet.refresh();

			addEmailDomain.orgRoleData.source = args[0] as Array;
			addEmailDomain.orgRoleData.refresh();
			addEmailDomain.orgEmailDomainDataSet = orgEmailDomainDataSet;
			addEmailDomain.currentState = '';

			nameInput.text = data['name'];
			pk = data['id'];
			externalUIDInput.text = data['external_uid'];
			externalUIDAutoEnroll.selected = data['use_external_uid'];
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			addEmailDomain.addEventListener(MouseEvent.CLICK, onEmailDomainAdded);
			addEmailDomain.remove.addEventListener(FlexEvent.BUTTON_DOWN, onClickRemove);
			BindingUtils.bindProperty(addEmailDomain.remove, 'enabled', orgEmailDomains, 'selectedItem');
			validators = [nameInput.validator, externalUIDInput.validator];
		}
		
		protected function onEmailDomainAdded(event:MouseEvent):void
		{
			if (event.target == addEmailDomain.confirm && addEmailDomain.selectedOrgRole)
			{
				var newOrgEmailDomain:Object = {
					'email_domain' : addEmailDomain.emailDomain,
					'organization' : pk,
					'role' : addEmailDomain.selectedOrgRole['id'],
					'effective_role_name' : addEmailDomain.selectedOrgRole['name']
				}
				if (newOrgEmailDomain.email_domain)
				{
					orgEmailDomainDataSet.addItem(newOrgEmailDomain);
				}
			}
		}

		protected function onClickRemove(event:FlexEvent):void
		{
			orgEmailDomainDataSet.removeItemAt(orgEmailDomainDataSet.getItemIndex(orgEmailDomains.selectedItem));
		}

	}
}