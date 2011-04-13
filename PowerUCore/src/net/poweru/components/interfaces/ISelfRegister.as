package net.poweru.components.interfaces
{
	import net.poweru.components.interfaces.ICreateDialog;
	
	public interface ISelfRegister extends ICreateDialog
	{
		function setCaptchaChallenge(challengeID:String, imageURL:String):void;
	}
}