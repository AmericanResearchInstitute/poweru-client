package net.poweru.utils
{
	import mx.collections.SortField;
	import mx.utils.ObjectUtil;
	
	import net.poweru.Constants;
	
	/*	Compare labels, considering that "All" and "None" should come first.
	Don't ever use this with more than one sort field. */
	public function CompareLabels(a:Object, b:Object, fields:Array=null):int
	{
		var aLabel:String;
		var bLabel:String;
		var ret:int = 0;
		
		if (fields != null && fields.length == 1)
		{
			/*	In the first round, we get SortField objects, and every
			time after we get strings.  I don't know why. */
			var field:Object = fields[0];
			if (field is SortField)
			{
				aLabel = a[(field as SortField).name];
				bLabel = b[(field as SortField).name];
			}
			else
			{
				aLabel = a[field as String];
				bLabel = b[field as String];
			}
		}
		else
		{
			aLabel = a as String;
			bLabel = b as String;
		}
		
		if (aLabel == Constants.ALL)
			ret = -1;
		else if (aLabel == Constants.NONE && bLabel != Constants.ALL)
			ret = -1;
		else if (bLabel == Constants.ALL)
			ret = 1;
		else if (bLabel == Constants.NONE && aLabel != Constants.ALL)
			ret = 1;
		else
			ret = ObjectUtil.stringCompare(aLabel, bLabel);
		
		return ret;
	}
}