package net.poweru.delegates
{
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	
	public class VideoManagerDelegate extends BaseDelegate
	{
		protected static const SPECIALUPDATEHANDLINGINFO:Object = {
			'category_relationships' : {
				'attribute_to_update' : 'categories',
				'foreign_attribute_name' : 'category',
				'attributes_to_include' : ['status']
			}
		}
		
		public function VideoManagerDelegate(responder:IResponder)
		{
			super(responder, 'VideoManager', null, SPECIALUPDATEHANDLINGINFO);
		}
		
		public function adminVideosView(authToken:String):void
		{
			var token:AsyncToken = remoteObject.getOperation('admin_videos_view').send(authToken);
			token.addResponder(responder);
		}
		
		public function userVideosView(authToken:String):void
		{
			var token:AsyncToken = remoteObject.getOperation('user_videos_view').send(authToken);
			token.addResponder(responder);
		}
	}
}