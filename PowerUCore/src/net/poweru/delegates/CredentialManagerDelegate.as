package net.poweru.delegates
{
	import mx.rpc.IResponder;
	
	public class CredentialManagerDelegate extends BaseDelegate
	{
		public function CredentialManagerDelegate(responder:IResponder)
		{
			super(responder, 'CredentialManager');
		}
	}
}