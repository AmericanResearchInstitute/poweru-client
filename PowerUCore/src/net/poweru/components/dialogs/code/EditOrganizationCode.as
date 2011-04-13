package net.poweru.components.dialogs.code
{
	import net.poweru.components.interfaces.IEditDialog;
	import net.poweru.components.dialogs.BaseCRUDDialog;
	import net.poweru.components.parts.AddEmailDomain;
	import net.poweru.model.DataSet;
	
	import flash.events.MouseEvent;
	
	import mx.binding.utils.BindingUtils;
	import mx.controls.DataGrid;
	import mx.events.FlexEvent;
	
	import net.poweru.generated.interfaces.IGeneratedTextInput;

	public class EditOrganizationCode extends BaseCRUDDialog implements IEditDialog
	{
		public var nameInput:IGeneratedTextInput;

		[Bindable]
		public var orgEmailDomains:DataGrid;
		[Bindable]
		protected var orgEmailDomainDataSet:DataSet;
		[Bindable]
		public var addEmailDomain:AddEmailDomain;
		
		protected var pk:Number;
		
		public function EditOrganizationCode()
		{
			super();
			orgEmailDomainDataSet = new DataSet();
		}
		
		public function clear():void
		{
			nameInput.text = '';
			pk = NaN;

			orgEmailDomainDataSet.source = [];
			orgEmailDomainDataSet.refresh();
		}
		
		override public function getData():Object
		{
			return {
				'name' : nameInput.text,
				'id' : pk,
				'org_email_domains' : orgEmailDomainDataSet.toArray()
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
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			addEmailDomain.addEventListener(MouseEvent.CLICK, onEmailDomainAdded);
			addEmailDomain.remove.addEventListener(FlexEvent.BUTTON_DOWN, onClickRemove);
			BindingUtils.bindProperty(addEmailDomain.remove, 'enabled', orgEmailDomains, 'selectedItem');
			validators = [nameInput.validator];
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