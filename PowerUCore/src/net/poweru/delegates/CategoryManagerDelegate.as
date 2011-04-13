package net.poweru.delegates
{
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	
	public class CategoryManagerDelegate extends BaseDelegate
	{
		public function CategoryManagerDelegate(responder:IResponder)
		{
			super(responder, 'CategoryManager');
		}
		
		public function adminCategoriesView(authToken:String):void
		{
			var token:AsyncToken = remoteObject.getOperation('admin_categories_view').send(authToken);
			token.addResponder(responder);
		}
	}
}