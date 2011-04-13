package net.poweru.utils
{
	import mx.collections.ArrayCollection;
	
	public class PKArrayCollection extends ArrayCollection
	{
		/*	Take an array of objects which have an 'id' field, and create only
			an array of those 'id' values.  If the insput is already an array
			of 'id' values, no change is made */
		public function PKArrayCollection(source:Array)
		{
			var newSource:Array = [];
				
			for each (var item:Object in source)
			{
				if (item.hasOwnProperty('id'))
					newSource.push(item['id']);
				else
					newSource.push(item);
			}
			
			super(newSource);
		}
		
	}
}