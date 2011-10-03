package net.poweru.components.parts.code
{
	import mx.containers.HBox;
	import mx.controls.CheckBox;
	import mx.controls.ComboBox;
	import mx.events.FlexEvent;
	
	import net.poweru.model.DataSet;
	
	public class SelectSessionRoleCode extends HBox
	{
		[Bindable]
		public var session:Object;
		public var roleComboBox:ComboBox;
		[Bindable]
		public var enrollCheckBox:CheckBox;
		
		public function SelectSessionRoleCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			roleComboBox.dataProvider = new DataSet(session['session_user_role_requirements'] as Array);
		}
	}
}