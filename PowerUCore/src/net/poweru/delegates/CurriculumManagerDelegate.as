package net.poweru.delegates
{
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;

	public class CurriculumManagerDelegate extends BaseDelegate
	{
		public function CurriculumManagerDelegate(responder:IResponder)
		{
			super(responder, 'CurriculumManager');
		}
		
	}
}