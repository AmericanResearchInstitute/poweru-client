package net.poweru.components.code
{
	import mx.containers.HBox;
	import mx.controls.List;
	
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
			dataProvider = new DataSet();
		}
	}
}