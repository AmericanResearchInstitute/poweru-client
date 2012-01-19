package net.poweru.delegates
{
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	
	public class VenueManagerDelegate extends BaseDelegate
	{
		public function VenueManagerDelegate(responder:IResponder)
		{
			super(responder, 'VenueManager');
		}
		
		public function getAvailableVenues(authToken:String, start:Date, end:Date, fields:Array):AsyncToken
		{
			var token:AsyncToken = remoteObject.getOperation('get_available_venues').send(authToken, mangleDate(start), mangleDate(end), fields);
			token.addResponder(responder);
			return token;
		}
	}
}