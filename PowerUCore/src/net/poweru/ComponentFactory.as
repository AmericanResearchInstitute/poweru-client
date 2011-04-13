package net.poweru
{
	import flash.display.DisplayObject;
	
	import net.poweru.components.Groups;
	import net.poweru.components.Login;
	import net.poweru.components.Organizations;
	import net.poweru.components.Users;
	import net.poweru.components.dialogs.ConfirmLogout;
	import net.poweru.components.dialogs.CreateGroup;
	import net.poweru.components.dialogs.CreateOrganization;
	import net.poweru.components.dialogs.CreateUser;
	import net.poweru.components.dialogs.EditGroup;
	import net.poweru.components.dialogs.EditOrganization;
	import net.poweru.components.dialogs.EditUser;
	import net.poweru.components.dialogs.HelpOrganization;
	import net.poweru.components.dialogs.HelpUser;
	import net.poweru.components.dialogs.ResetPassword;
	import net.poweru.components.dialogs.SelfRegister;
	import net.poweru.placemanager.ComponentFactory;
	import net.poweru.placemanager.IComponentFactory;
	import net.poweru.presenters.ConfirmLogoutMediator;
	import net.poweru.presenters.CreateGroupMediator;
	import net.poweru.presenters.CreateOrganizationMediator;
	import net.poweru.presenters.CreateUserMediator;
	import net.poweru.presenters.EditGroupMediator;
	import net.poweru.presenters.EditOrganizationMediator;
	import net.poweru.presenters.EditUserMediator;
	import net.poweru.presenters.GroupsMediator;
	import net.poweru.presenters.LoginMediator;
	import net.poweru.presenters.OrganizationsMediator;
	import net.poweru.presenters.ResetPasswordMediator;
	import net.poweru.presenters.SelfRegisterMediator;
	import net.poweru.presenters.UsersMediator;

	public class ComponentFactory extends net.poweru.placemanager.ComponentFactory implements IComponentFactory
	{
		public function ComponentFactory()
		{
			super();
		}
		
		public static function getInstance():IComponentFactory
		{
			if (instance == null)
				instance = new net.poweru.ComponentFactory();
			return instance;
		}
		
		override public function getComponent(name:String):DisplayObject
		{
			var component:DisplayObject;
			
			switch (name)
			{
				case Places.CONFIRMLOGOUT:
					component = getOrCreate(name, ConfirmLogout, ConfirmLogoutMediator);
					break;
				
				case Places.CREATEGROUP:
					component = getOrCreate(name, CreateGroup, CreateGroupMediator);
					break;
					
				case Places.CREATEORGANIZATION:
					component = getOrCreate(name, CreateOrganization, CreateOrganizationMediator);
					break;
					
				case Places.CREATEUSER:
					component = getOrCreate(name, CreateUser, CreateUserMediator);
					break;
				
				case Places.EDITGROUP:
					component = getOrCreate(name, EditGroup, EditGroupMediator);
					break;
				
				case Places.EDITORGANIZATION:
					component = getOrCreate(name, EditOrganization, EditOrganizationMediator);
					break;
				
				case Places.EDITUSER:
					component = getOrCreate(name, EditUser, EditUserMediator);
					break;
				
				case Places.GROUPS:
					component = getOrCreate(name, Groups, GroupsMediator);
					break;
				
				case Places.HELPUSER:
					component = getOrCreate(name, HelpUser);
					break;
				
				case Places.HELPORGANIZATION:
					component = getOrCreate(name, HelpOrganization);
					break;
				
				case Places.LOGIN:
					component = getOrCreate(name, Login, LoginMediator);
					break;
					
				case Places.ORGANIZATIONS:
					component = getOrCreate(name, Organizations, OrganizationsMediator);
					break;
				
				case Places.RESETPASSWORD:
					component = getOrCreate(name, ResetPassword, ResetPasswordMediator);
					break;
				
				case Places.SELFREGISTER:
					component = getOrCreate(name, SelfRegister, SelfRegisterMediator);
					break;
				
				case Places.USERS:
					component = getOrCreate(name, Users, UsersMediator);
					break;
				
				default:
					component = super.getComponent(name);
			}
			
			return component;
		}
		
	}
}