package net.poweru.utils
{
	import mx.utils.ObjectUtil;
	import mx.utils.StringUtil;

	public function SortCompareFunctionFactory(fields:Array, caseInsensitive:Boolean=true):Function
	{
		var f:Function = function(obj1:Object, obj2:Object):int
		{
			var obj1_value:Object = obj1;
			var obj2_value:Object = obj2;
			for each (var field:Object in fields)
			{
				obj1_value = obj1_value[field as String];
				obj2_value = obj2_value[field as String];
			}
			obj1_value = (!obj1_value) ? '' : obj1_value;
			obj2_value = (!obj2_value) ? '' : obj2_value;
			obj1_value = StringUtil.trim(obj1_value as String);
			obj2_value = StringUtil.trim(obj2_value as String);

			return ObjectUtil.stringCompare(obj1_value as String,
											obj2_value as String,
											caseInsensitive);
		}
		return f;
	}
}