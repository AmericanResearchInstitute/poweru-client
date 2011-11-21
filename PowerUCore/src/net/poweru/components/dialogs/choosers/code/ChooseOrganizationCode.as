package net.poweru.components.dialogs.choosers.code
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Tree;
	import mx.events.FlexEvent;
	
	import net.poweru.components.dialogs.BaseDialog;
	import net.poweru.components.dialogs.choosers.interfaces.IChooser;
	import net.poweru.model.HierarchicalDataSet;
	
	public class ChooseOrganizationCode extends BaseDialog implements IChooser
	{
		[Bindable]
		public var organizations:Tree;
		
		public function ChooseOrganizationCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		public function populate(data:Array, ...args):void
		{
			organizations.dataProvider.source = data;
			organizations.dataProvider.refresh();
			// make sure all nodes are open
			organizations.validateNow();
			for each (var organization:Object in organizations.dataProvider)
				organizations.expandChildrenOf(organization, true);
		}
		
		public function clear():void
		{
			populate([]);
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			organizations.dataProvider = new HierarchicalDataSet();
		}
	}
}