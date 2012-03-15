package net.poweru.proxies
{
	import com.adobe.utils.DateUtil;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import net.poweru.ApplicationFacade;
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.StateNames;
	import net.poweru.delegates.UserManagerDelegate;
	import net.poweru.model.DataSet;
	import net.poweru.utils.PowerUResponder;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;

	/*	Stores the authToken in a cookie if possible, and if not, stores it locally */
	public class LoginProxy extends Proxy implements IProxy
	{
		public static const NAME:String = 'LoginProxy';
		
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
			authToken = null;
			authSuccessInThisSession = false;
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
			
			determineState();
			
			// This handler is also used by the relogin operation
			if (!authSuccessInThisSession)
			{
				sendNotification(NotificationNames.LOGINSUCCESS, currentUser);
				authSuccessInThisSession = true;
			}
		}
		
		protected function determineState():void
		{
			var newState:String = '';
			
			if (currentUser['status'] == 'pending')
				newState = StateNames.PENDING_USER;
			else if (userGroups.findByKey('name', LegacyGroupProxy.SUPERADMINGROUP))
				newState = StateNames.SUPERADMIN;
			else if (userGroups.findByKey('name', LegacyGroupProxy.CATEGORYMANAGERGROUP))
				newState = StateNames.CATEGORYMANAGER;
			else if (userGroups.findByKey('name', LegacyGroupProxy.STUDENTGROUP))
				newState = StateNames.STUDENT;
			else if ((currentUser['organizations'] as Array).length == 0)
				newState = StateNames.NO_ORG_USER;
			else
				newState = StateNames.USER;
				
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