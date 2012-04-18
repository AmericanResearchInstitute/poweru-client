package net.poweru.utils
{
	/*	Return true iff the two items are equal. This supports other types
	(currently only Date) that do not compare properly with the ==
	operator. */
	public function ItemsAreEqual(item1:Object, item2:Object):Boolean
	{
		var ret:Boolean = false;
		if (item1 is Date && item2 is Date)
		{
			ret = ((item1 as Date).getTime() == (item2 as Date).getTime());
		}
		else
		{
			ret = (item1 == item2);
		}
		return ret;
	}
}