package net.poweru.delegates
{
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	
	public class CurriculumEnrollmentManagerDelegate extends BaseDelegate
	{
		public function CurriculumEnrollmentManagerDelegate(responder:IResponder)
		{
			super(responder, 'CurriculumEnrollmentManager', null, null);
			mangleMap = {
				'start' : mangleDate,
				'end' : mangleDate
			};
		}
		
		public function curriculumEnrollmentsView(authToken:String, pks:Array=null):void
		{
			var token:AsyncToken = remoteObject.getOperation('curriculum_enrollments_view').send(authToken, pks ? pks : null);
			token.addResponder(responder);
		}
	}
}