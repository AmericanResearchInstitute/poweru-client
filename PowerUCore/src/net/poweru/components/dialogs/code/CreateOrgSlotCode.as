package net.poweru.components.dialogs.code
{
	import mx.collections.ArrayCollection;
	import mx.controls.CheckBox;
	import mx.controls.ComboBox;
	import mx.controls.Label;
	import mx.events.FlexEvent;
	import mx.validators.NumberValidator;
	import mx.validators.StringValidator;
	
	import net.poweru.Places;
	import net.poweru.components.dialogs.BaseCRUDDialog;
	import net.poweru.components.interfaces.ICreateOrgSlot;
	
	public class CreateOrgSlotCode extends BaseCRUDDialog implements ICreateOrgSlot
	{
		[Bindable]
		public var roleInput:ComboBox;
		public var roleValidator:NumberValidator;
		
		[Bindable]
		protected var chosenOrganization:Object;
		
		public function CreateOrgSlotCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		public function clear():void
		{
			roleInput.selectedItem = null;
			chosenOrganization = null;
		}
		
		public function populate(roles:Array, organization:Object):void
		{
			roleInput.dataProvider.source = roles;
			roleInput.dataProvider.refresh();
			chosenOrganization = organization;
		}
		
		override public function getData():Object
		{
			return {
				'organization' : chosenOrganization.id,
				'role' : roleInput.selectedItem.id,
				'persistent' : true
			}
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			roleInput.dataProvider = new ArrayCollection();
			validators = [
				roleValidator
			];
		}
	}
}