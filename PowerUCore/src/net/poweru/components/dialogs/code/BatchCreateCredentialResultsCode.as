package net.poweru.components.dialogs.code
{
	import mx.collections.ArrayCollection;
	
	import net.poweru.components.dialogs.BaseDialog;
	import net.poweru.components.interfaces.IObjectPopulatedComponent;
	import net.poweru.model.DataSet;
	import net.poweru.utils.BatchRequestTracker;
	import net.poweru.utils.SortedDataSetFactory;
	
	public class BatchCreateCredentialResultsCode extends BaseDialog implements IObjectPopulatedComponent
	{
		[Bindable]
		protected var successResults:DataSet;
		[Bindable]
		protected var errorResults:DataSet;
		
		public function BatchCreateCredentialResultsCode()
		{
			super();
			successResults = SortedDataSetFactory.singleFieldSort('user.last_name');
			errorResults = SortedDataSetFactory.singleFieldSort('user.last_name');
		}
		
		public function populate(data:Object):void
		{
			successResults.source = data.success;
			successResults.refresh();
			errorResults.source = data.error;
			errorResults.refresh();
		}
		
		public function clear():void
		{
			populate(new BatchRequestTracker());
		}
	}
}