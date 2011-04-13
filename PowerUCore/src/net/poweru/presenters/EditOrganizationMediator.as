package net.poweru.presenters
{
	import net.poweru.ApplicationFacade;
	import net.poweru.NotificationNames;
	import net.poweru.Places;
	import net.poweru.events.ViewEvent;
	import net.poweru.model.DataSet;
	import net.poweru.presenters.BaseEditDialogMediator;
	import net.poweru.proxies.AdminOrganizationViewProxy;
	import net.poweru.proxies.OrgEmailDomainProxy;
	import net.poweru.proxies.OrgRoleProxy;
	import net.poweru.utils.InputCollector;
	
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;

	public class EditOrganizationMediator extends BaseEditDialogMediator implements IMediator
	{
		public static const NAME:String = 'EditOrganizationMediator';
		
		protected var orgEmailDomainProxy:OrgEmailDomainProxy;
		protected var orgRoleProxy:OrgRoleProxy;
		protected var inputCollector:InputCollector;
		
		public function EditOrganizationMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent, AdminOrganizationViewProxy, Places.EDITORGANIZATION);
			orgEmailDomainProxy = (facade as ApplicationFacade).retrieveOrRegisterProxy(OrgEmailDomainProxy) as OrgEmailDomainProxy;
			orgRoleProxy = (facade as ApplicationFacade).retrieveOrRegisterProxy(OrgRoleProxy) as OrgRoleProxy;
			inputCollector = new InputCollector([]);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				NotificationNames.LOGOUT,
				NotificationNames.DIALOGPRESENTED,
				NotificationNames.UPDATEORGROLES
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case NotificationNames.LOGOUT:
					if (editDialog)
						editDialog.clear();
					break;
					
				case NotificationNames.DIALOGPRESENTED:
					var body:String = notification.getBody() as String;
					if (body != null && body == placeName)
						populate();
					break;

				case NotificationNames.UPDATEORGROLES:
					var orgRoles:DataSet = notification.getBody() as DataSet;
					inputCollector.addInput('organization_roles', orgRoles.toArray());
					break;
			}
		}

		override protected function onSubmit(event:ViewEvent):void
		{
			var newObject:Object = event.body;
			primaryProxy.save(newObject);
			
			var cmpOrgEmailDomain:Function = function(item:*, index:int, array:Array):Boolean
			{
				var orgEmailDomain:Object = item;
				if (orgEmailDomain.email_domain == this.email_domain)
				{
					if (orgEmailDomain.hasOwnProperty('role') && (orgEmailDomain.role == this.role || orgEmailDomain.role == this.effective_role))
					{
						return true;
					}
					else if (orgEmailDomain.hasOwnProperty('effective_role') && (orgEmailDomain.effective_role == this.role || orgEmailDomain.effective_role == this.effective_role))
					{
						return true;
					}
				}
				return false;
			};
			var currentOrgEmailDomains:Array = primaryProxy.findByPK(inputCollector.object['orgData']['id'])['org_email_domains'];
			var newOrgEmailDomains:Array = event.body.org_email_domains;
			for each (var currentOrgEmailDomain:Object in currentOrgEmailDomains)
			{
				if (!newOrgEmailDomains.some(cmpOrgEmailDomain, currentOrgEmailDomain))
				{
					orgEmailDomainProxy.deleteObject(currentOrgEmailDomain['id']);
				}
			}
			for each (var newOrgEmailDomain:Object in newOrgEmailDomains)
			{
				if (!currentOrgEmailDomains.some(cmpOrgEmailDomain, newOrgEmailDomain))
				{
					orgEmailDomainProxy.create(newOrgEmailDomain);
				}
			}
			sendNotification(NotificationNames.REMOVEDIALOG, displayObject);
		}
		
		override protected function populate():void
		{
			if (inputCollector)
				inputCollector.removeEventListener(Event.COMPLETE, onInputsCollected);
				
			inputCollector = new InputCollector(['orgData', 'organization_roles']);
			inputCollector.addEventListener(Event.COMPLETE, onInputsCollected);
			var pk:Number = initialDataProxy.getInitialData(placeName) as Number;
			var initialData:Object = primaryProxy.findByPK(pk);

			if (initialData == null)
			{
				// fields are not necessary since we override the proxy to use a view
				primaryProxy.getOne(pk, []);
			}
			else
			{
				inputCollector.addInput('orgData', initialData);
			}
			orgRoleProxy.getAll(['name']);
			primaryProxy.getChoices();
		}

		protected function onInputsCollected(event:Event):void
		{
			var collector:InputCollector = event.target as InputCollector;
			editDialog.populate(collector.object['orgData'], collector.object['organization_roles'] as Array);
		}
	}
}