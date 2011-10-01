package net.poweru.model
{
	import mx.collections.ArrayCollection;

	public class DataSet extends ArrayCollection
	{
		public function DataSet(source:Array=null)
		{
			super(source);
		}
		
		// returns null if not found
		public function findByPK(pk:Number):Object
		{
			return findByKey('id', pk);
		}
		
		// returns null if not found.  Returns first hit if multiple are found.
		public function findByKey(key:String, value:Object, source:Array=null):Object
		{
			source = source ? source : this.source;
			
			for each (var item:Object in source)
				if (item.hasOwnProperty(key) && item[key] == value)
					return item;
			return null;
		}
		
		public function removeByPK(pk:Number):void
		{
			removeByKey('id', pk);
		}
		
		public function removeByKey(key:String, value:Object, array:Array=null):void
		{
			for each (var item:Object in source)
				if (item.hasOwnProperty(key) && item[key] == value)
				{	
					removeItemAt(getItemIndex(item))
					break;
				}
		}
		
		/*	returns as many of the requested items as it finds, but does not
		raise an error if one or more are not found. */
		public function findMembersByPK(pks:Array):DataSet
		{
			return findMembersByKey('id', pks);
		}
		
		/*	returns as many of the requested items as it finds, but does not
			raise an error if one or more are not found. */
		public function findMembersByKey(key:String, values:Array):DataSet
		{
			var results:Array = [];
			for each (var value:Number in values)
			{
				var item:Object = findByKey(key, value);
				if (item != null)
					results.push(item);
			}
			return new DataSet(results);
		}
		
		public function addOrReplace(data:Object, key:String=null):void
		{
			key = key ? key : 'id';
			var item:Object = findByKey(key, data[key]);
			if (item)
				removeByPK(item['id']);
			addItem(data);
		}
		
		/*	adds all items specified, removing old ones of the same ID. */
		public function mergeData(data:Array):void
		{
			for each (var item:Object in data)
				addOrReplace(item);
		}
	}
}