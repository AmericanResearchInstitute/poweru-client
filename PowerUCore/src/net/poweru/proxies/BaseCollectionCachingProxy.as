package net.poweru.proxies
{
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;
	
	import net.poweru.model.DataSet;
	
	import org.puremvc.as3.interfaces.IProxy;
	
	/*	This is useful when a proxy is used by calling getFiltered with an 'exact' filter
		included. For example, get all rooms for a particular venue. This proxy will
		cache that collection of rooms using the venue as a cache key.
	
		This proxy will act like a normal BaseProxy for all getFiltered() calls that do
		not include the cacheKeyName in an 'exact' filter.
	*/
	public class BaseCollectionCachingProxy extends BaseProxy implements IProxy
	{
		protected var cacheKeyName:String;
		protected var resultCache:Object;
		
		public function BaseCollectionCachingProxy(proxyName:String, primaryDelegateClass:Class, updatedDataNotification:String, fields:Array, cacheKeyName:String, modelName:String=null, choiceFields:Array=null)
		{
			super(proxyName, primaryDelegateClass, updatedDataNotification, fields, modelName, choiceFields);
			this.cacheKeyName = cacheKeyName;
			resultCache = {};
		}
		
		// looks for the collection in our cache before making a remote call
		override public function getFiltered(filters:Object, uid:String=null):void
		{
			if (filters.hasOwnProperty('exact') && filters['exact'].hasOwnProperty(cacheKeyName))
			{
				var keyValue:Number = filters['exact'][cacheKeyName];
				if (resultCache.hasOwnProperty(keyValue))
					sendNotification(updatedDataNotification, new DataSet(resultCache[keyValue]), filters.toString());
				else
					super.getFiltered(filters);
			}
			else
				super.getFiltered(filters);
		}
		
		// saves results to our cache if an exact filter with cacheKeyName is found
		override protected function onGetFilteredSuccess(data:ResultEvent):void
		{
			super.onGetFilteredSuccess(data);
			
			var filters:Object = data.token['filters'];
			if (filters.hasOwnProperty('exact') && filters['exact'].hasOwnProperty(cacheKeyName))
			{
				var value:Array = data.result.value as Array;
				var keyValue:Number = filters['exact'][cacheKeyName];
				resultCache[keyValue] = value;
			}
		}
		
		override public function clear():void
		{
			super.clear();
			resultCache = {};
		}
	}
}