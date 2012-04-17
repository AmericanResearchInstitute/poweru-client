package net.poweru.presenters
{
	import net.poweru.Places;
	import net.poweru.proxies.CredentialProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	
	public class BatchCreateCredentialResultsDialogMediator extends BaseBatchCreateResultsDialogMediator implements IMediator
	{
		public static const NAME:String = 'BatchCreateCredentialResultsDialogMediator';
		
		public function BatchCreateCredentialResultsDialogMediator(viewComponent:Object)
		{
			super(NAME, viewComponent, CredentialProxy, Places.BATCHCREATECREDENTIALSRESULTS);
		}
	}
}