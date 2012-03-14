package net.poweru.components.dialogs.code
{
	import flash.events.Event;
	
	import mx.controls.TextInput;
	
	import net.poweru.components.dialogs.BaseCRUDDialog;
	import net.poweru.components.interfaces.ISelfRegister;
	import net.poweru.components.widgets.ReCaptcha;
	import net.poweru.components.widgets.TitleComboBox;
	import net.poweru.events.ViewEvent;
	import net.poweru.generated.interfaces.IGeneratedTextInput;

	public class SelfRegisterCode extends BaseCRUDDialog implements ISelfRegister
	{
		[Bindable] public var first:IGeneratedTextInput;
		[Bindable] public var last:IGeneratedTextInput;
		[Bindable] public var email:IGeneratedTextInput;
		[Bindable] public var titleInput:TitleComboBox;
		[Bindable] public var phone:IGeneratedTextInput;
		[Bindable] public var password1:TextInput;
		[Bindable] public var password2:TextInput;
		[Bindable] public var username:IGeneratedTextInput;
		[Bindable] public var organization:TextInput;
		[Bindable] public var organizationExternalID:TextInput;
		[Bindable] public var captcha:ReCaptcha;
		
		protected var captchaChallenge:String;
		
		
		public function SelfRegisterCode()
		{
			super();
		}
		
		override public function getData():Object
		{
			return {
				'title' : titleInput.text,
				'first_name' : first.text,
				'last_name' : last.text,
				'email' : email.text,
				'phone' : phone.text,
				'username' : username.text,
				'password' : password1.text,
				'status' : 'pending',
				'external_uid' : organizationExternalID.text,
				'alleged_organization' : organization.text,
				'recaptcha_challenge' : captchaChallenge,
				'recaptcha_response' : captcha.response.text
			};
		}
		
		override public function clear():void
		{
			first.text = '';
			last.text = '';
			titleInput.text = '';
			email.text = '';
			phone.text = '';
			username.text = '';
			password1.text = '';
			password2.text = '';
			organization.text = '';
			organizationExternalID.text = '';
			clearCaptcha();
		}
		
		public function clearCaptcha():void
		{
			captcha.clear();
		}
		
		public function setCaptchaChallenge(challengeID:String, imageURL:String):void
		{
			captcha.image.load(imageURL);
			captchaChallenge = challengeID;
			captcha.response.text = '';
		}
		
		protected function onCreationComplete(event:Event):void
		{
			captcha.addEventListener(ViewEvent.REFRESH, onRefresh);
			validators.push(first.validator, last.validator, email.validator, username.validator, captcha.validator);
		}
		
		protected function onRefresh(event:ViewEvent):void
		{
			dispatchEvent(new ViewEvent(ViewEvent.REFRESH));
		}
	}
}