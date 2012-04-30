package net.poweru.components.code
{
	import mx.controls.CheckBox;
	
	import net.poweru.components.interfaces.IArrayPopulatedComponent;
	import net.poweru.model.DataSet;

	public class BaseActivePopulatedComponentCode extends BasePopulatedComponentCode implements IArrayPopulatedComponent
	{
		[Bindable]
		public var showInactiveInput:CheckBox;
		
		public function BaseActivePopulatedComponentCode()
		{
			super();
		}
		
		protected function filterInactive(item:Object):Boolean
		{
			if (showInactiveInput != null && showInactiveInput.selected == true)
				return true;
			else
				return !(item.hasOwnProperty('active') && item.active == false);
		}
		
		override protected function getNewDataSet():DataSet
		{
			var ret:DataSet = super.getNewDataSet();
			ret.filterFunction = filterInactive;
			return ret;
		}
	}
}