package net.poweru.components.widgets
{
	import net.poweru.Constants;
	
	import mx.collections.ArrayCollection;
	import mx.controls.ComboBox;
	import mx.utils.ObjectUtil;

	public class TitleComboBox extends ComboBox
	{
		public static const NONE:String = '<none>';
		
		public function TitleComboBox()
		{
			super();
			dataProvider = new ArrayCollection(ObjectUtil.copy(Constants.HONORIFICS) as Array);
			(dataProvider as ArrayCollection).addItemAt(NONE, 0);
			editable = true;
			selectedItem = dataProvider[0];
		}
		
		override public function get text():String
		{
			var ret:String = super.text;
			if (ret == NONE)
				ret = '';
			return ret;
		}
		
	}
}