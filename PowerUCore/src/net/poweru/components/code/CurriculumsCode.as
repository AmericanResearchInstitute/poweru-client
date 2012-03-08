package net.poweru.components.code
{
	import mx.collections.ArrayCollection;
	import mx.containers.HBox;
	import mx.controls.List;
	import mx.events.FlexEvent;
	
	import net.poweru.components.interfaces.ICurriculums;
	import net.poweru.model.DataSet;
	import net.poweru.utils.SortedDataSetFactory;
	
	public class CurriculumsCode extends HBox implements ICurriculums
	{
		[Bindable]
		public var curriculumList:List;
		
		[Bindable]
		protected var dataProvider:DataSet;
		
		public function CurriculumsCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
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
			dataProvider = SortedDataSetFactory.singleFieldSort('name');
		}
	}
}