package net.poweru
{
	import flash.display.DisplayObject;
	
	import net.poweru.components.CurriculumEnrollments;
	import net.poweru.components.Curriculums;
	import net.poweru.components.EventTemplates;
	import net.poweru.components.Events;
	import net.poweru.components.Exams;
	import net.poweru.components.FileDownloads;
	import net.poweru.components.Groups;
	import net.poweru.components.Login;
	import net.poweru.components.Organizations;
	import net.poweru.components.SessionUserRoles;
	import net.poweru.components.Users;
	import net.poweru.components.Venues;
	import net.poweru.components.dialogs.AddTasksToCurriculum;
	import net.poweru.components.dialogs.BulkEnrollInEvent;
	import net.poweru.components.dialogs.ConfirmLogout;
	import net.poweru.components.dialogs.CreateCurriculum;
	import net.poweru.components.dialogs.CreateCurriculumEnrollment;
	import net.poweru.components.dialogs.CreateEvent;
	import net.poweru.components.dialogs.CreateEventFromTemplate;
	import net.poweru.components.dialogs.CreateEventTemplate;
	import net.poweru.components.dialogs.CreateExam;
	import net.poweru.components.dialogs.CreateExamFromXML;
	import net.poweru.components.dialogs.CreateGroup;
	import net.poweru.components.dialogs.CreateOrgSlot;
	import net.poweru.components.dialogs.CreateOrganization;
	import net.poweru.components.dialogs.CreateRoom;
	import net.poweru.components.dialogs.CreateSession;
	import net.poweru.components.dialogs.CreateSessionTemplate;
	import net.poweru.components.dialogs.CreateSessionUserRole;
	import net.poweru.components.dialogs.CreateUser;
	import net.poweru.components.dialogs.CreateVenue;
	import net.poweru.components.dialogs.EditCurriculum;
	import net.poweru.components.dialogs.EditEnrollments;
	import net.poweru.components.dialogs.EditEvent;
	import net.poweru.components.dialogs.EditEventTemplate;
	import net.poweru.components.dialogs.EditExam;
	import net.poweru.components.dialogs.EditFileDownload;
	import net.poweru.components.dialogs.EditGroup;
	import net.poweru.components.dialogs.EditOrganization;
	import net.poweru.components.dialogs.EditRoom;
	import net.poweru.components.dialogs.EditSession;
	import net.poweru.components.dialogs.EditSessionTemplate;
	import net.poweru.components.dialogs.EditSessionUserRole;
	import net.poweru.components.dialogs.EditUser;
	import net.poweru.components.dialogs.EditUserOrgRole;
	import net.poweru.components.dialogs.EditVenue;
	import net.poweru.components.dialogs.EmailSessionParticipants;
	import net.poweru.components.dialogs.HelpOrganization;
	import net.poweru.components.dialogs.HelpUser;
	import net.poweru.components.dialogs.ResetPassword;
	import net.poweru.components.dialogs.SelfRegister;
	import net.poweru.components.dialogs.UploadCSV;
	import net.poweru.components.dialogs.UploadFileDownload;
	import net.poweru.components.dialogs.choosers.ChooseOrganization;
	import net.poweru.components.dialogs.choosers.ChooseRoom;
	import net.poweru.components.dialogs.choosers.ChooseUser;
	import net.poweru.components.student.Assignments;
	import net.poweru.components.student.SessionAssignments;
	import net.poweru.components.student.ExamAssignments;
	import net.poweru.components.student.FileDownloadAssignments;
	import net.poweru.placemanager.ComponentFactory;
	import net.poweru.placemanager.IComponentFactory;
	import net.poweru.presenters.AddTasksToCurriculumMediator;
	import net.poweru.presenters.BulkEnrollInEventMediator;
	import net.poweru.presenters.ChooseOrganizationMediator;
	import net.poweru.presenters.ChooseRoomMediator;
	import net.poweru.presenters.ChooseUserMediator;
	import net.poweru.presenters.ConfirmLogoutMediator;
	import net.poweru.presenters.CreateCurriculumEnrollmentMediator;
	import net.poweru.presenters.CreateCurriculumMediator;
	import net.poweru.presenters.CreateEventFromTemplateMediator;
	import net.poweru.presenters.CreateEventMediator;
	import net.poweru.presenters.CreateEventTemplateMediator;
	import net.poweru.presenters.CreateExamFromXMLMediator;
	import net.poweru.presenters.CreateExamMediator;
	import net.poweru.presenters.CreateGroupMediator;
	import net.poweru.presenters.CreateOrgSlotMediator;
	import net.poweru.presenters.CreateOrganizationMediator;
	import net.poweru.presenters.CreateRoomMediator;
	import net.poweru.presenters.CreateSessionMediator;
	import net.poweru.presenters.CreateSessionTemplateMediator;
	import net.poweru.presenters.CreateSessionUserRoleMediator;
	import net.poweru.presenters.CreateUserMediator;
	import net.poweru.presenters.CreateVenueMediator;
	import net.poweru.presenters.CurriculumEnrollmentMediator;
	import net.poweru.presenters.CurriculumsMediator;
	import net.poweru.presenters.EditCurriculumMediator;
	import net.poweru.presenters.EditEnrollmentsMediator;
	import net.poweru.presenters.EditEventMediator;
	import net.poweru.presenters.EditEventTemplateMediator;
	import net.poweru.presenters.EditExamMediator;
	import net.poweru.presenters.EditFileDownloadMediator;
	import net.poweru.presenters.EditGroupMediator;
	import net.poweru.presenters.EditOrganizationMediator;
	import net.poweru.presenters.EditRoomMediator;
	import net.poweru.presenters.EditSessionMediator;
	import net.poweru.presenters.EditSessionTemplateMediator;
	import net.poweru.presenters.EditSessionUserRoleMediator;
	import net.poweru.presenters.EditUserMediator;
	import net.poweru.presenters.EditUserOrgRoleMediator;
	import net.poweru.presenters.EditVenueMediator;
	import net.poweru.presenters.EventTemplatesMediator;
	import net.poweru.presenters.EventsMediator;
	import net.poweru.presenters.ExamsMediator;
	import net.poweru.presenters.FileDownloadsMediator;
	import net.poweru.presenters.GroupsMediator;
	import net.poweru.presenters.LoginMediator;
	import net.poweru.presenters.OrganizationsMediator;
	import net.poweru.presenters.ResetPasswordMediator;
	import net.poweru.presenters.SelfRegisterMediator;
	import net.poweru.presenters.SessionUserRolesMediator;
	import net.poweru.presenters.TasksMediator;
	import net.poweru.presenters.UploadFileDownloadMediator;
	import net.poweru.presenters.UserUploadCSVMediator;
	import net.poweru.presenters.UsersMediator;
	import net.poweru.presenters.VenuesMediator;
	import net.poweru.presenters.student.AssignmentsMediator;
	import net.poweru.presenters.student.SessionAssignmentMediator;
	import net.poweru.presenters.student.ExamAssignmentsMediator;
	import net.poweru.presenters.student.FileDownloadAssignmentsMediator;

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
				case Places.ADDTASKSTOCURRICULUM:
					component = getOrCreate(name, AddTasksToCurriculum, AddTasksToCurriculumMediator);
					break;
				
				case Places.BULKENROLLINEVENT:
					component = getOrCreate(name, BulkEnrollInEvent, BulkEnrollInEventMediator);
					break;
				
				case Places.CHOOSEORGANIZATION:
					component = getOrCreate(name, ChooseOrganization, ChooseOrganizationMediator);
					break;
				
				case Places.CHOOSEROOM:
					component = getOrCreate(name, ChooseRoom, ChooseRoomMediator);
					break;
				
				case Places.CHOOSEUSER:
					component = getOrCreate(name, ChooseUser, ChooseUserMediator);
					break;
				
				case Places.CONFIRMLOGOUT:
					component = getOrCreate(name, ConfirmLogout, ConfirmLogoutMediator);
					break;
				
				case Places.CREATECURRICULUM:
					component = getOrCreate(name, CreateCurriculum, CreateCurriculumMediator);
					break;
				
				case Places.CREATECURRICULUMENROLLMENT:
					component = getOrCreate(name, CreateCurriculumEnrollment, CreateCurriculumEnrollmentMediator);
					break;
				
				case Places.CREATEEVENT:
					component = getOrCreate(name, CreateEvent, CreateEventMediator);
					break;
				
				case Places.CREATEEVENTFROMTEMPLATE:
					component = getOrCreate(name, CreateEventFromTemplate, CreateEventFromTemplateMediator);
					break;
				
				case Places.CREATEEVENTTEMPLATE:
					component = getOrCreate(name, CreateEventTemplate, CreateEventTemplateMediator);
					break;
				
				case Places.CREATEEXAM:
					component = getOrCreate(name, CreateExam, CreateExamMediator);
					break;
				
				case Places.CREATEEXAMFROMXML:
					component = getOrCreate(name, CreateExamFromXML, CreateExamFromXMLMediator);
					break;
				
				case Places.CREATEGROUP:
					component = getOrCreate(name, CreateGroup, CreateGroupMediator);
					break;
					
				case Places.CREATEORGANIZATION:
					component = getOrCreate(name, CreateOrganization, CreateOrganizationMediator);
					break;
				
				case Places.CREATEORGANIZATIONSLOT:
					component = getOrCreate(name, CreateOrgSlot, CreateOrgSlotMediator);
					break;
				
				case Places.CREATEROOM:
					component = getOrCreate(name, CreateRoom, CreateRoomMediator);
					break;
				
				case Places.CREATESESSION:
					component = getOrCreate(name, CreateSession, CreateSessionMediator);
					break;
				
				case Places.CREATESESSIONTEMPLATE:
					component = getOrCreate(name, CreateSessionTemplate, CreateSessionTemplateMediator);
					break;
				
				case Places.CREATESESSIONUSERROLE:
					component = getOrCreate(name, CreateSessionUserRole, CreateSessionUserRoleMediator);
					break;
					
				case Places.CREATEUSER:
					component = getOrCreate(name, CreateUser, CreateUserMediator);
					break;
				
				case Places.CREATEVENUE:
					component = getOrCreate(name, CreateVenue, CreateVenueMediator);
					break;
				
				case Places.CURRICULUMENROLLMENTS:
					component = getOrCreate(name, CurriculumEnrollments, CurriculumEnrollmentMediator);
					break;
				
				case Places.CURRICULUMS:
					component = getOrCreate(name, Curriculums, CurriculumsMediator);
					break;
				
				case Places.EDITCURRICULUM:
					component = getOrCreate(name, EditCurriculum, EditCurriculumMediator);
					break;
				
				case Places.EDITENROLLMENTS:
					component = getOrCreate(name, EditEnrollments, EditEnrollmentsMediator);
					break;
				
				case Places.EDITEVENT:
					component = getOrCreate(name, EditEvent, EditEventMediator);
					break;
				
				case Places.EDITEVENTTEMPLATE:
					component = getOrCreate(name, EditEventTemplate, EditEventTemplateMediator);
					break;
				
				case Places.EDITEXAM:
					component = getOrCreate(name, EditExam, EditExamMediator);
					break;
				
				case Places.EDITGROUP:
					component = getOrCreate(name, EditGroup, EditGroupMediator);
					break;
				
				case Places.EDITFILEDOWNLOAD:
					component = getOrCreate(name, EditFileDownload, EditFileDownloadMediator);
					break;
				
				case Places.EDITORGANIZATION:
					component = getOrCreate(name, EditOrganization, EditOrganizationMediator);
					break;
				
				case Places.EDITROOM:
					component = getOrCreate(name, EditRoom, EditRoomMediator);
					break;
				
				case Places.EDITSESSION:
					component = getOrCreate(name, EditSession, EditSessionMediator);
					break;
				
				case Places.EDITSESSIONTEMPLATE:
					component = getOrCreate(name, EditSessionTemplate, EditSessionTemplateMediator);
					break;
				
				case Places.EDITSESSIONUSERROLE:
					component = getOrCreate(name, EditSessionUserRole, EditSessionUserRoleMediator);
					break;
				
				case Places.EDITUSER:
					component = getOrCreate(name, EditUser, EditUserMediator);
					break;
				
				case Places.EDITUSERORGROLE:
					component = getOrCreate(name, EditUserOrgRole, EditUserOrgRoleMediator);
					break;
				
				case Places.EDITVENUE:
					component = getOrCreate(name, EditVenue, EditVenueMediator);
					break;
				
				case Places.EMAILSESSIONPARTICIPANTS:
					component = getOrCreate(name, EmailSessionParticipants);
					break;
				
				case Places.EVENTASSIGNMENTS:
					component = getOrCreate(name, SessionAssignments, SessionAssignmentMediator);
					break;
				
				case Places.EVENTS:
					component = getOrCreate(name, Events, EventsMediator);
					break;
				
				case Places.EVENTTEMPLATES:
					component = getOrCreate(name, EventTemplates, EventTemplatesMediator);
					break;
				
				case Places.EXAMS:
					component = getOrCreate(name, Exams, ExamsMediator);
					break;
				
				case Places.EXAMASSIGNMENTS:
					component = getOrCreate(name, ExamAssignments, ExamAssignmentsMediator);
					break;
				
				case Places.FILEDOWNLOADS:
					component = getOrCreate(name, FileDownloads, FileDownloadsMediator);
					break;
				
				case Places.FILEDOWNLOADASSIGNMENTS:
					component = getOrCreate(name, FileDownloadAssignments, FileDownloadAssignmentsMediator);
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
				
				case Places.IMPORTUSERS:
					component = getOrCreate(name, UploadCSV, UserUploadCSVMediator);
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
				
				case Places.SESSIONUSERROLES:
					component = getOrCreate(name, SessionUserRoles, SessionUserRolesMediator);
					break;
				
				case Places.STUDENTASSIGNMENTS:
					component = getOrCreate(name, Assignments, AssignmentsMediator);
					break;
				
				case Places.UPLOADFILEDOWNLOAD:
					component = getOrCreate(name, UploadFileDownload, UploadFileDownloadMediator);
					break;
				
				case Places.USERS:
					component = getOrCreate(name, Users, UsersMediator);
					break;
				
				case Places.VENUES:
					component = getOrCreate(name, Venues, VenuesMediator);
					break;
				
				default:
					component = super.getComponent(name);
			}
			
			return component;
		}
		
	}
}