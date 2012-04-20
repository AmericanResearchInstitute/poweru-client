package net.poweru.components.interfaces
{
	public interface ISelfRegister extends ICreateDialog
	{
		function setCaptchaChallenge(challengeID:String, imageURL:String):void;
		function clearCaptcha():void;
	}
}