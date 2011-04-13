package net.poweru.proxies
{
	import net.poweru.NotificationNames;
	import net.poweru.delegates.OrganizationManagerDelegate;
	import net.poweru.model.DataSet;
	import net.poweru.model.HierarchicalDataSet;
	import net.poweru.utils.PowerUResponder;
	
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectUtil;
	
	import org.puremvc.as3.interfaces.IProxy;

	public class OrganizationProxy extends BaseProxy implements IProxy
	{
		public static const NAME:String = 'OrganizationProxy';

		public function OrganizationProxy()
		{
			super(NAME, OrganizationManagerDelegate, NotificationNames.UPDATEORGANIZATIONS);
		}
		
		override public function create(parameters:Object):void
		{
			var argNamesInOrder:Array = ['name'];
			var args:Array = [loginProxy.authToken];
			for each (var argName:String in argNamesInOrder)
			{
				args.push(parameters[argName]);
			}
			
			new primaryDelegateClass(new PowerUResponder(onCreateSuccess, onCreateError, onFault)).create.apply(this, args);
		}
	}
}