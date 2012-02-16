package net.poweru.delegates
{
	import mx.rpc.IResponder;
	
	public class MessageTemplateManagerDelegate extends BaseDelegate
	{
		public function MessageTemplateManagerDelegate(responder:IResponder)
		{
			super(responder, 'MessageTemplateManager', ['message_format', 'message_type']);
		}
	}
}