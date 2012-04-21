package net.poweru.delegates
{
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.events.ResultEvent;
	
	import net.poweru.model.DataSet;
	import net.poweru.utils.InputCollector;
	import net.poweru.utils.PowerUResponder;
	
	public class UserManagerDelegate extends BaseDelegate
	{
		protected var authToken:String;
		
		protected static const SPECIALUPDATEHANDLINGINFO:Object = {
			'owned_userorgroles' : {
				'attribute_to_update' : 'organizations',
				'foreign_attribute_name' : 'organization',
				'attributes_to_include' : ['role']
			}
		}
		
		public function UserManagerDelegate(responder:IResponder)
		{
			super(responder, 'UserManager', ['default_username_and_domain'], SPECIALUPDATEHANDLINGINFO);
			init();
		}
		
		private function init():void
		{
			mangleMap = {'organizations' : mangleOrganizations};
		}
		
		public function login(username:String, password:String):void
		{
			var token:AsyncToken = remoteObject.getOperation('login').send(username, password);
			token.addResponder(responder);
		}
		
		public function logout(authToken:String):void
		{
			var token:AsyncToken = remoteObject.getOperation('logout').send(authToken);
			token.addResponder(responder);	
		}
		
		public function relogin(authToken:String):void
		{
			var token:AsyncToken = remoteObject.getOperation('relogin').send(authToken);
			token.addResponder(responder);	
		}
		
		public function resetPassword(username:String, email:String):void
		{
			var token:AsyncToken = remoteObject.getOperation('reset_password').send(username, email);
			token.addResponder(responder);
		} 
		
		public function adminUsersView(authToken:String, pks:Array=null):void
		{
			var token:AsyncToken = remoteObject.getOperation('admin_users_view').send(authToken, pks);
			token.addResponder(responder);
		}
		
		public function getUsersByGroupName(authToken:String, name:String, fields:Array):void
		{
			var token:AsyncToken = remoteObject.getOperation('get_users_by_group_name').send(authToken, name, fields);
			token.addResponder(responder);
			token.groupName = name;
		}
		
		public function changePassword(authToken:String, userId:Number, password:String, oldPassword:String):void
		{
			var token:AsyncToken = remoteObject.getOperation('change_password').send(authToken, userId, password, oldPassword);
			token.addResponder(responder);
		}
		
		/*	obtain a single use auth token. If an InputCollector is specified,
			it will be added to the AsyncToken under key 'inputCollector'. */
		public function obtainSingleUseAuthToken(authToken:String, inputCollector:InputCollector=null):void
		{
			var token:AsyncToken = remoteObject.getOperation('obtain_single_use_auth_token').send(authToken);
			token.addResponder(responder);
			if (inputCollector)
				token['inputCollector'] = inputCollector;
		}
		
		public function getCaptchaChallenge():void
		{
			var token:AsyncToken = remoteObject.getOperation('get_recaptcha_challenge').send();
			token.addResponder(responder);
		}
		
		public function sendEmail(authToken:String, users:Array, subject:String, body:String):void
		{
			var token:AsyncToken = remoteObject.getOperation('send_email').send(authToken, users, subject, body);
			token.addResponder(responder);
		}
		
		
		/*	Organization relationships are different than most M2M because there can be more than one relationship
			between user and org as long as a different role is specified.  This makes removing these relationships
			challenging.  This method does so, and is a bit non-conventional in that it directly calls
			another delegate (UserOrgRoleManagerDelegate) to delete the relationship objects.
		*/
		protected function mangleOrganizations(value:Object, attributeName:String, oldItem:Object, newItem:Object):Object
		{
			var removeList:Array = value['remove'] as Array;
			var oldList:DataSet = new DataSet(oldItem['owned_userorgroles'] as Array);
			var newList:DataSet = new DataSet(newItem['owned_userorgroles'] as Array);
			while (removeList.length > 0)
			{
				var fk:Number = removeList.pop() as Number;
				var relationshipToRemove:Object = null;
				// find one instance of this in oldItem that also isn't in newItem
				for each (var relationship:Object in oldList)
				{
					if (relationship['organization'] == fk)
					{
						// See if we find this relationship on the new item
						var foundInNewItem:Boolean = false;
						for each (var item:Object in newList)
						{
							if (item['organization'] == fk && item['role'] == relationship['role'])
							{
								foundInNewItem = true;
								break;
							}
						}
						
						// If not found on new item, proceed with deletion!
						if (!foundInNewItem)
						{
							relationshipToRemove = relationship;
							oldList.removeByPK(relationship['id']);
							break;
						}
					}
				}
				if (relationshipToRemove != null)
				{
					// actually delete it
					var deleteResponder:PowerUResponder = new PowerUResponder(orgDeleteSuccess, orgDeleteError, responder.fault);
					new UserOrgRoleManagerDelegate(deleteResponder).deleteObject(authToken, relationshipToRemove['id']);
				}
			}
			
			value['remove'] = [];
			return value;
		}
		
		// grab the auth token, which we might need for deleting org relationships.
		override public function update(authToken:String, oldItem:Object, newItem:Object):void
		{
			this.authToken = authToken;
			super.update(authToken, oldItem, newItem);
		}
		
		protected function orgDeleteSuccess(data:ResultEvent):void
		{
			
		}

		protected function orgDeleteError(data:ResultEvent):void
		{
			
		}

	}
}