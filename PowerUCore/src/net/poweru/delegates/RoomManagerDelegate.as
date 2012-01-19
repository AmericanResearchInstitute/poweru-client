package net.poweru.delegates
{
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	
	public class RoomManagerDelegate extends BaseDelegate
	{
		public function RoomManagerDelegate(responder:IResponder)
		{
			super(responder, 'RoomManager');
		}
		
		public function getAvailableRooms(authToken:String, start:Date, end:Date, IDs:Array, fields:Array):AsyncToken
		{
			var token:AsyncToken = remoteObject.getOperation('get_available_rooms').send(authToken, mangleDate(start), mangleDate(end), IDs, fields);
			token.addResponder(responder);
			return token;
		}
	}
}