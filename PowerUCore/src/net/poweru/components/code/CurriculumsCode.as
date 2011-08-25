package net.poweru.components.code
{
	import mx.collections.ArrayCollection;
	import mx.containers.HBox;
	import mx.controls.List;
	import mx.events.FlexEvent;
	
	import net.poweru.components.interfaces.ICurriculums;
	import net.poweru.model.DataSet;
	
	public class CurriculumsCode extends HBox implements ICurriculums
	{
		[Bindable]
		protected var dataProvider:DataSet;
		
		[Bindable]
		public var curriculumList:List;
		
		public function CurriculumsCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			dataProvider = new DataSet();
		}
		
		public function populate(data:Array):void
		{
			curriculumList.dataProvider.source = data;
			curriculumList.dataProvider.refresh();
		}
		
		public function clear():void
		{
			populate([]);
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			curriculumList.dataProvider = new ArrayCollection();
		}
	}
}