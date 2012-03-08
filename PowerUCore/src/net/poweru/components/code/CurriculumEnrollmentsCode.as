package net.poweru.components.code
{
	import mx.collections.ArrayCollection;
	import mx.containers.HBox;
	import mx.events.FlexEvent;
	
	import net.poweru.components.interfaces.ICurriculumEnrollments;
	import net.poweru.model.DataSet;
	import net.poweru.utils.SortedDataSetFactory;
	
	public class CurriculumEnrollmentsCode extends HBox implements ICurriculumEnrollments
	{
		[Bindable]
		protected var dataProvider:DataSet;
		
		public function CurriculumEnrollmentsCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			dataProvider = new DataSet();
		}
		
		public function populate(data:Array):void
		{
			dataProvider.source = data;
			dataProvider.refresh();
		}
		
		public function clear():void
		{
			populate([]);
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			dataProvider = SortedDataSetFactory.singleFieldSort('start');
		}
		
		protected function formatName(item:Object):String
		{
			var ret:String = '';
			ret += item.last_name;
			ret += ', ';
			ret += item.first_name;
			return ret;
		}
	}
}