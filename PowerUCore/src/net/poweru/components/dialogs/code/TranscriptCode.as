package net.poweru.components.dialogs.code
{
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.events.FlexEvent;
	
	import net.poweru.components.dialogs.BaseDialog;
	import net.poweru.components.interfaces.ITranscript;
	import net.poweru.model.DataSet;
	import net.poweru.utils.LabelFunctions;
	import net.poweru.utils.SortedDataSetFactory;
	
	public class TranscriptCode extends BaseDialog implements ITranscript
	{
		[Bindable]
		protected var assignmentDataSet:DataSet;
		[Bindable]
		protected var achievementAwardsDataSet:DataSet;
		[Bindable]
		protected var credentialsDataSet:DataSet;
		
		public function TranscriptCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		public function populate(assignments:Array, achievementAwards:Array, credentials:Array):void
		{
			assignmentDataSet.source = assignments;
			assignmentDataSet.refresh();
			achievementAwardsDataSet.source = achievementAwards;
			achievementAwardsDataSet.refresh();
			credentialsDataSet.source = credentials;
			credentialsDataSet.refresh();
		}
		
		public function clear():void
		{
			populate([], [], []);
		}
		
		protected function getLabelFromTask(item:Object, column:DataGridColumn):String
		{
			return LabelFunctions.taskType(item['task'], column);
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			achievementAwardsDataSet = SortedDataSetFactory.singleFieldSort('achievement_name');
			assignmentDataSet = SortedDataSetFactory.singleFieldDateSort('date_completed');
			credentialsDataSet = SortedDataSetFactory.singleFieldSort('credential_type.name');
		}
	}
}