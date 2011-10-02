package net.poweru.components.code
{
	import mx.containers.HBox;
	import mx.controls.List;
	import mx.events.FlexEvent;
	
	import net.poweru.components.interfaces.ISessionUserRoles;
	import net.poweru.model.DataSet;
	
	public class SessionUserRoleCode extends HBox implements ISessionUserRoles
	{
		[Bindable]
		public var list:List;
		
		public function SessionUserRoleCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		public function populate(data:Array):void
		{
			list.dataProvider.source = data;
			list.dataProvider.refresh();
		}
		
		public function clear():void
		{
			populate([]);
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			list.dataProvider = new DataSet();
		}
	}
}