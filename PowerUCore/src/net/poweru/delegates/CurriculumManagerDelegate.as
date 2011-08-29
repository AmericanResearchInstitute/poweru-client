package net.poweru.delegates
{
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;

	public class CurriculumManagerDelegate extends BaseDelegate
	{
		protected static const SPECIALUPDATEHANDLINGINFO:Object = {
			// name of the attribute as seen on the flex object
			'curriculum_task_associations' : {
				// name of the corresponding attribute on the back end.
				'attribute_to_update' : 'tasks',
				// in each relationship definition, this is the name of
				// the attribute holding the FK of M2M relationship
				'foreign_attribute_name' : 'task',
				// Considering the attributes of each relationship's object,
				// include this list of attributes in the update request
				'attributes_to_include' : []
			}
		};
		
		public function CurriculumManagerDelegate(responder:IResponder)
		{
			super(responder, 'CurriculumManager', null, SPECIALUPDATEHANDLINGINFO);
		}
		
		public function adminCurriculumsView(authToken:String):void
		{
			var token:AsyncToken = remoteObject.getOperation('admin_curriculums_view').send(authToken);
			token.addResponder(responder);
		}
		
	}
}