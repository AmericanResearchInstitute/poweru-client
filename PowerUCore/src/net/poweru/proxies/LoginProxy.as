package net.poweru.proxies
{
	import com.adobe.utils.DateUtil;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.UIDUtil;
	
	import net.poweru.ApplicationFacade;
	import net.poweru.Constants;
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.StateNames;
	import net.poweru.delegates.UserManagerDelegate;
	import net.poweru.model.ChooserRequest;
	import net.poweru.model.DataSet;
	import net.poweru.utils.PowerUResponder;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;

	/*	This could easily be renamed to "SessionProxy", as it manages the session
		data including current user info, auth token, application state (which
		defines what user role is experienced), etc.
		
		Stores the authToken in a cookie if possible, and if not, stores it locally.
	*/
	public class LoginProxy extends Proxy implements IProxy
	{
		public static const NAME:String = 'LoginProxy';
		public static const ORG_BASED_STATES:Array = [
			StateNames.OWNERMANAGER,
			StateNames.ORG_ADMIN,
			StateNames.ADMIN_ASSISTANT,
			StateNames.SERV_DEALER_ADMIN
		];
		
		protected var _authToken:String;
		protected var _userPK:Number;
		protected var _userGroups:DataSet;
		protected var _applicationState:String;
		protected var _currentUser:Object;
		protected var browserServicesProxy:BrowserServicesProxy;
		protected var reloginTimer:Timer;
		// Has this instance of the app been able to login or relogin since
		// the last logout?
		protected var authSuccessInThisSession:Boolean = false;
		public var associatedOrgs:Array = [];
		protected var _activeUserOrgRole:Object;
		
		public function LoginProxy(data:Object=null)
		{
			super(NAME, data);
			_userGroups = new DataSet();
			browserServicesProxy = (facade as ApplicationFacade).retrieveOrRegisterProxy(BrowserServicesProxy) as BrowserServicesProxy;
		}
		
		public function isMemberOfGroup(name:String):Boolean
		{
			return (userGroups.findByKey('name', name) != null);
		}
		
		public function get authToken():String
		{
			var ret:String;
			if (browserServicesProxy.canUseCookies)
				ret = browserServicesProxy.getCookie('authToken');
			else
				ret = _authToken;
			return ret;
		}
		
		public function set authToken(value:String):void
		{
			if (browserServicesProxy.canUseCookies)
			{
				if (value == null)
					browserServicesProxy.deleteCookie('authToken');
				else
					browserServicesProxy.setCookie('authToken', value);
			}
			else
				_authToken = value;
		}
		
		public function get applicationState():String
		{
			return _applicationState;
		}
		
		public function set applicationState(newState:String):void
		{
			_applicationState = newState;
			sendNotification(NotificationNames.STATECHANGE, newState);
		}
		
		public function get userPK():Number
		{
			return _userPK;
		}
		
		public function get userGroups():DataSet
		{
			return _userGroups;
		}
		
		public function get currentUser():Object
		{
			return _currentUser;
		}
		
		public function get activeUserOrgRole():Object
		{
			return _activeUserOrgRole;
		}
		
		public function set activeUserOrgRole(item:Object):void
		{
			_activeUserOrgRole = item;
			if (item == null)
			{
				associatedOrgs = [];
				applicationState = null;
			}
			else
			{
				var activeOrg:Number = activeUserOrgRole.organization;
				associatedOrgs = [activeOrg];
				var currentUserOrgsDataSet:DataSet = new DataSet(currentUser.organizations as Array);
				associatedOrgs = associatedOrgs.concat(currentUserOrgsDataSet.findByPK(activeOrg).descendants as Array);
			}
			determineState();
		}
		
		protected function timerSetup(milliseconds:Number):void
		{
			reloginTimer = new Timer(milliseconds, 1);
			reloginTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onReloginTimer);
			reloginTimer.start();
		}
		
		protected function timerTearDown():void
		{
			if (reloginTimer != null)
			{
				reloginTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onReloginTimer);
				reloginTimer.stop();
				reloginTimer = null;
			}
		}
		
		protected function clear():void
		{
			authToken = null;
			authSuccessInThisSession = false;
			associatedOrgs = [];
			activeUserOrgRole = null;
			applicationState = null;
			_userPK = -1;
			_userGroups = new DataSet();
			_currentUser = null;
		}
		
		public function sendLoginSuccess():void
		{
			sendNotification(NotificationNames.LOGINSUCCESS, currentUser);
			authSuccessInThisSession = true;
		}
		
		
		// Remote Methods
		
		public function login(username:String, password:String):void
		{
			new UserManagerDelegate(new PowerUResponder(onLoginSuccess, onLoginFailure, fault)).login(username, password);
		}
		
		public function logout():void
		{
			new UserManagerDelegate(new Responder(logoutResult, fault)).logout(authToken);
			timerTearDown();
			sendNotification(NotificationNames.LOGOUT);
			clear();
		}
		
		// Looks for an existing auth token in a cookie, and if found, logs in with that.
		public function attemptRelogin():void
		{
			if (authToken != null)
				new UserManagerDelegate(new PowerUResponder(onLoginSuccess, onReloginFailure, onReloginFault, true)).relogin(authToken);
			else
				sendNotification(NotificationNames.SETSPACE, Places.LOGIN);
		}
		
		public function resetPassword(username:String, email:String):void
		{
			new UserManagerDelegate(new PowerUResponder(onResetPasswordSuccess, onResetPasswordFailure, fault, true)).resetPassword(username, email);
		}
		
		public function getCaptchaChallenge():void
		{
			new UserManagerDelegate(new PowerUResponder(onCaptchaChallengeSuccess, onCaptchaChallengeError, fault)).getCaptchaChallenge();
		}
		
		protected function userIsOwnerManager(user:Object):Boolean
		{
			return userHasOrgRoleByName(user, Constants.OWNER_MANAGER);
		}
		
		protected function userIsOrgAdmin(user:Object):Boolean
		{
			return userHasOrgRoleByName(user, Constants.ORG_ADMIN);
		}
		
		protected function userHasOrgRoleByName(user:Object, roleName:String):Boolean
		{
			var ret:Boolean = false;
			if (user.hasOwnProperty('owned_userorgroles') && (user.owned_userorgroles as Array) != null)
			{
				for each (var userorgrole:Object in (user.owned_userorgroles as Array))
				{
					if (userorgrole.role_name == roleName)
					{
						ret = true;
						break;
					}
				}
			}
			return ret;
		}
		
		
		// Result handlers
		
		protected function onCaptchaChallengeSuccess(data:ResultEvent):void
		{
			sendNotification(NotificationNames.CAPTCHACHALLENGE, data.result['value']);
		}
		
		protected function onCaptchaChallengeError(data:ResultEvent):void
		{
			trace('captcha error');
		}
		
		protected function onReloginFailure(data:ResultEvent):void
		{
			// We failed to relogin, so show the login place
			sendNotification(NotificationNames.LOGOUT);
			authSuccessInThisSession = false;
			authToken = null;
			timerTearDown();
		}
		
		/*	This indicated a problem such as with a network connection. Thus,
			we will now try once per minute to relogin until we are successful. */
		protected function onReloginFault(event:FaultEvent):void
		{
			timerTearDown();
			timerSetup(60000);
		}
		
		protected function onLoginSuccess(data:ResultEvent):void
		{
			_currentUser = data.result.value;
			with (data.result.value)
			{
				this.authToken = auth_token;
				_userGroups.source = groups;
				_userGroups.refresh();
				_userPK = id;
			}
			
			var expiration:Date = DateUtil.parseW3CDTF(data.result.value.expiration);
			
			var delay:Number = (expiration.getTime() - new Date().getTime()) * .5;
			timerSetup(delay);
			
			// This handler is also used by the relogin operation
			if (!authSuccessInThisSession)
			{
				if (userHasAnyOrgScopedRole(currentUser))
				{
					var currentUserOrgRoles:Array = currentUser.owned_userorgroles as Array;
					if (currentUserOrgRoles.length == 1)
					{
						activeUserOrgRole = currentUserOrgRoles[0];
						sendLoginSuccess();
					}
					else
						sendNotification(NotificationNames.SHOWDIALOG, [Places.CHOOSELOGINCONTEXT, new ChooserRequest(UIDUtil.createUID())]);
				}
				else
				{
					determineState();
					sendLoginSuccess();
				}
			}
		}
		
		protected function userHasAnyOrgScopedRole(user:Object):Boolean
		{
			var ret:Boolean = false;
			if (!userGroups.findByKey('name', GroupProxy.SUPERADMINGROUP))
			{
				for each (var roleName:String in [Constants.ORG_ADMIN, Constants.OWNER_MANAGER, Constants.SERV_DEALER_ADMIN, Constants.ADMIN_ASSISTANT])
				{
					if (userHasOrgRoleByName(user, roleName))
					{
						ret = true;
						break;
					}
				}
			}
			return ret;
		}
		
		protected function determineState():void
		{
			var newState:String = '';
			
			//	determine org-scoped state based on the chosen login context
			if (activeUserOrgRole != null)
			{
				switch (activeUserOrgRole.role_name)
				{
					case Constants.OWNER_MANAGER:
						newState = StateNames.OWNERMANAGER;
						break;
					
					case Constants.ORG_ADMIN:
						newState = StateNames.ORG_ADMIN;
						break;
					
					case Constants.SERV_DEALER_ADMIN:
						newState = StateNames.SERV_DEALER_ADMIN;
						break;
					
					case Constants.ADMIN_ASSISTANT:
						newState = StateNames.ADMIN_ASSISTANT;
						break;
				}
			}
			//	does not consider org-scoped roles
			else
			{
				if (currentUser['status'] == 'pending')
					newState = StateNames.PENDING_USER;
				else if (userGroups.findByKey('name', GroupProxy.SUPERADMINGROUP))
					newState = StateNames.SUPERADMIN;
				else if (userGroups.findByKey('name', GroupProxy.CATEGORYMANAGERGROUP))
					newState = StateNames.CATEGORYMANAGER;
				else if (userGroups.findByKey('name', GroupProxy.STUDENTGROUP))
					newState = StateNames.STUDENT;
				else if ((currentUser['organizations'] as Array).length == 0)
					newState = StateNames.NO_ORG_USER;
				else
					newState = StateNames.USER;
			}
			applicationState = newState;
		}
		
		protected function onLoginFailure(data:ResultEvent):void
		{
			sendNotification(NotificationNames.LOGINFAILURE);
		}
		
		protected function onReloginTimer(event:TimerEvent):void
		{
			attemptRelogin();
		}
		
		protected function logoutResult(data:ResultEvent):void
		{
			
		}
		
		protected function onResetPasswordSuccess(data:ResultEvent):void
		{
			trace('password reset successful');
			sendNotification(NotificationNames.RESETPASSWORDSUCCESS);
		}
		
		protected function onResetPasswordFailure(data:ResultEvent):void
		{
			trace('password reset failed');
			sendNotification(NotificationNames.RESETPASSWORDFAILURE);
		}
		
		protected function fault(info:Object):void
		{
			trace('auth call failed');
		}
	}
}