package net.poweru.proxies
{
	import mx.rpc.events.ResultEvent;
	
	import net.poweru.NotificationNames;
	import net.poweru.delegates.CategoryManagerDelegate;
	import net.poweru.model.DataSet;
	import net.poweru.utils.PowerUResponder;
	
	import org.puremvc.as3.interfaces.IProxy;
	
	public class CategoryProxy extends BaseProxy implements IProxy
	{
		public static const NAME:String = 'CategoryProxy';
		public static const FIELDS:Array = ['name'];
		
		public function CategoryProxy()
		{
			super(NAME, CategoryManagerDelegate, NotificationNames.UPDATECATEGORIES, FIELDS);
		}
		
		public function adminCategoriesView():void
		{
			new CategoryManagerDelegate(new PowerUResponder(onAdminCategoriesViewSuccess, onAdminCategoriesViewError, onFault)).adminCategoriesView(loginProxy.authToken);
		}
		
		protected function onAdminCategoriesViewSuccess(event:ResultEvent):void
		{
			data = new DataSet(event.result.value);
			sendNotification(NotificationNames.UPDATEADMINCATEGORIESVIEW, event.result.value);
		}
		
		protected function onAdminCategoriesViewError(event:ResultEvent):void
		{
			
		}
		
		override protected function onCreateSuccess(data:ResultEvent):void
		{
			adminCategoriesView();
		}
		
		override public function create(argDict:Object):void
		{
			var argNamesInOrder:Array = ['name'];
			var args:Array = [loginProxy.authToken];
			for each (var argName:String in argNamesInOrder)
			{
				args.push(argDict[argName]);
			}
			
			new primaryDelegateClass(new PowerUResponder(onCreateSuccess, onCreateError, onFault)).create.apply(this, args);
		}
		
	}
}