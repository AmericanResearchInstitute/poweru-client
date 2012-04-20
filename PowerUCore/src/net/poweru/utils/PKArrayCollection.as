package net.poweru.utils
{
	import mx.collections.ArrayCollection;
	
	public class PKArrayCollection extends ArrayCollection
	{
		/*	Take an array of objects which have a key field, and create only
			an array of corresponding values. For each object, if the key field
			does not exist, it is assumed to already be the value and is added
			directly. This allows you to have a mix of complete object dictionaries
			and isolated primary keys in the same source Array. */
		public function PKArrayCollection(source:Array, key:String=null)
		{
			super(createNewSource(source, key));
		}
		
		protected function createNewSource(source:Array, key:String=null):Array
		{
			var newSource:Array = [];
			if (key == null)
				key = 'id';
			
			for each (var item:Object in source)
			{
				if (item.hasOwnProperty(key))
					newSource.push(item[key]);
				else
					newSource.push(item);
			}
			return newSource;
		}
		
	}
}