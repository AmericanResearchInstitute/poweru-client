package net.poweru.delegates
{
	import mx.rpc.IResponder;
	
	public class RoomManagerDelegate extends BaseDelegate
	{
		public function RoomManagerDelegate(responder:IResponder)
		{
			super(responder, 'RoomManager');
		}
	}
}