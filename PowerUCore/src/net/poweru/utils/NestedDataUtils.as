package net.poweru.utils
{
	import mx.utils.ObjectUtil;

	public class NestedDataUtils
	{
		public function NestedDataUtils()
		{
		}
		
		/*	For any item in the collection, return a nested Object based on
		dot-delimited path names, just as you would normally access it in
		AS3.
		
		For example, set "nestedNames" to "user.status", pass in an item with
		a 'user' property, and this will return that user's status.
		*/
		public static function getFinalObject(x:Object, namePieces:Array):Object
		{
			return _getFinalObject(x, ObjectUtil.copy(namePieces) as Array);
		}
		
		private static function _getFinalObject(x:Object, namePieces:Array):Object
		{
			var ret:Object = x;
			if (x != null && namePieces.length > 0)
			{
				ret = getFinalObject(x[namePieces.shift()], namePieces);
			}
			return ret;
		}
			
	}
}