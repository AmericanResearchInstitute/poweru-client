package net.poweru.delegates
{
	import mx.rpc.IResponder;
	
	public class SessionManagerDelegate extends BaseDelegate
	{
		public function SessionManagerDelegate(responder:IResponder)
		{
			super(responder, 'SessionManager');
			mangleMap = {
				'start' : mangleDate,
				'end' : mangleDate
			};
		}
	}
}