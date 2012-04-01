package net.poweru
{
	import flash.display.DisplayObject;
	
	import net.poweru.components.Achievements;
	import net.poweru.components.Assignments;
	import net.poweru.components.CredentialTypes;
	import net.poweru.components.CurriculumEnrollments;
	import net.poweru.components.Curriculums;
	import net.poweru.components.EventTemplates;
	import net.poweru.components.Events;
	import net.poweru.components.Exams;
	import net.poweru.components.FileDownloads;
	import net.poweru.components.Groups;
	import net.poweru.components.Login;
	import net.poweru.components.MessageTemplates;
	import net.poweru.components.NoOrgUser;
	import net.poweru.components.Organizations;
	import net.poweru.components.PendingUser;
	import net.poweru.components.SessionUserRoles;
	import net.poweru.components.TaskBundles;
	import net.poweru.components.Users;
	import net.poweru.components.Venues;
	import net.poweru.components.collections.Admin;
	import net.poweru.components.collections.AssignmentsTab;
	import net.poweru.components.collections.CredentialManagement;
	import net.poweru.components.collections.CurriculumManagement;
	import net.poweru.components.collections.UserManagement;
	import net.poweru.components.dialogs.AddTasksToCurriculum;
	import net.poweru.components.dialogs.AdministerExamSession;
	import net.poweru.components.dialogs.BulkAssignmentResults;
	import net.poweru.components.dialogs.BulkEnrollInEvent;
	import net.poweru.components.dialogs.ConfirmLogout;
	import net.poweru.components.dialogs.CreateAchievement;
	import net.poweru.components.dialogs.CreateBlackoutPeriod;
	import net.poweru.components.dialogs.CreateCredentialType;
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
	import net.poweru.components.dialogs.CreateSessionUserRoleRequirement;
	import net.poweru.components.dialogs.CreateTaskBundle;
	import net.poweru.components.dialogs.CreateTaskFee;
	import net.poweru.components.dialogs.CreateUser;
	import net.poweru.components.dialogs.CreateVenue;
	import net.poweru.components.dialogs.EditAchievement;
	import net.poweru.components.dialogs.EditAssignment;
	import net.poweru.components.dialogs.EditBlackoutPeriod;
	import net.poweru.components.dialogs.EditCredentialType;
	import net.poweru.components.dialogs.EditCurriculum;
	import net.poweru.components.dialogs.EditCurriculumEnrollment;
	import net.poweru.components.dialogs.EditEnrollments;
	import net.poweru.components.dialogs.EditEvent;
	import net.poweru.components.dialogs.EditEventTemplate;
	import net.poweru.components.dialogs.EditExam;
	import net.poweru.components.dialogs.EditFileDownload;
	import net.poweru.components.dialogs.EditGroup;
	import net.poweru.components.dialogs.EditMessageTemplate;
	import net.poweru.components.dialogs.EditOrganization;
	import net.poweru.components.dialogs.EditRoom;
	import net.poweru.components.dialogs.EditSession;
	import net.poweru.components.dialogs.EditSessionTemplate;
	import net.poweru.components.dialogs.EditSessionUserRole;
	import net.poweru.components.dialogs.EditSessionUserRoleRequirement;
	import net.poweru.components.dialogs.EditTaskBundle;
	import net.poweru.components.dialogs.EditUser;
	import net.poweru.components.dialogs.EditUserOrgRole;
	import net.poweru.components.dialogs.EditVenue;
	import net.poweru.components.dialogs.EmailSessionParticipants;
	import net.poweru.components.dialogs.HelpOrganization;
	import net.poweru.components.dialogs.HelpUser;
	import net.poweru.components.dialogs.ResetPassword;
	import net.poweru.components.dialogs.SelfRegister;
	import net.poweru.components.dialogs.Transcript;
	import net.poweru.components.dialogs.UploadCSV;
	import net.poweru.components.dialogs.UploadFileDownload;
	import net.poweru.components.dialogs.ViewExamAssignments;
	import net.poweru.components.dialogs.ViewFileDownloadAssignments;
	import net.poweru.components.dialogs.choosers.ChooseAchievement;
	import net.poweru.components.dialogs.choosers.ChooseExam;
	import net.poweru.components.dialogs.choosers.ChooseFileDownload;
	import net.poweru.components.dialogs.choosers.ChooseGroup;
	import net.poweru.components.dialogs.choosers.ChooseOrgRole;
	import net.poweru.components.dialogs.choosers.ChooseOrganization;
	import net.poweru.components.dialogs.choosers.ChooseRoom;
	import net.poweru.components.dialogs.choosers.ChooseTask;
	import net.poweru.components.dialogs.choosers.ChooseTaskBundle;
	import net.poweru.components.dialogs.choosers.ChooseUser;
	import net.poweru.components.dialogs.choosers.ChooseUserStatus;
	import net.poweru.components.student.CurriculumEnrollments;
	import net.poweru.components.student.ExamAssignments;
	import net.poweru.components.student.FileDownloadAssignments;
	import net.poweru.components.student.SessionAssignments;
	import net.poweru.placemanager.ComponentFactory;
	import net.poweru.placemanager.IComponentFactory;
	import net.poweru.presenters.AchievementsMediator;
	import net.poweru.presenters.AddTasksToCurriculumMediator;
	import net.poweru.presenters.AdminMediator;
	import net.poweru.presenters.AdministerExamSessionMediator;
	import net.poweru.presenters.AssignmentsMediator;
	import net.poweru.presenters.BulkAssignmentResultsMediator;
	import net.poweru.presenters.BulkEnrollInEventMediator;
	import net.poweru.presenters.ChooseAchievementMediator;
	import net.poweru.presenters.ChooseExamMediator;
	import net.poweru.presenters.ChooseFileDownloadMediator;
	import net.poweru.presenters.ChooseGroupMediator;
	import net.poweru.presenters.ChooseOrgRoleMediator;
	import net.poweru.presenters.ChooseOrganizationMediator;
	import net.poweru.presenters.ChooseRoomMediator;
	import net.poweru.presenters.ChooseTaskBundleMediator;
	import net.poweru.presenters.ChooseTaskMediator;
	import net.poweru.presenters.ChooseUserMediator;
	import net.poweru.presenters.ChooseUserStatusMediator;
	import net.poweru.presenters.ConfirmLogoutMediator;
	import net.poweru.presenters.CreateAchievementMediator;
	import net.poweru.presenters.CreateBlackoutPeriodMediator;
	import net.poweru.presenters.CreateCredentialTypeMediator;
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
	import net.poweru.presenters.CreateSessionUserRoleRequirementMediator;
	import net.poweru.presenters.CreateTaskBundleMediator;
	import net.poweru.presenters.CreateTaskFeeMediator;
	import net.poweru.presenters.CreateUserMediator;
	import net.poweru.presenters.CreateVenueMediator;
	import net.poweru.presenters.CredentialManagementMediator;
	import net.poweru.presenters.CredentialTypesMediator;
	import net.poweru.presenters.CurriculumEnrollmentMediator;
	import net.poweru.presenters.CurriculumManagementMediator;
	import net.poweru.presenters.CurriculumsMediator;
	import net.poweru.presenters.EditAchievementMediator;
	import net.poweru.presenters.EditAssignmentMediator;
	import net.poweru.presenters.EditBlackoutPeriodMediator;
	import net.poweru.presenters.EditCredentialTypeMediator;
	import net.poweru.presenters.EditCurriculumEnrollmentMediator;
	import net.poweru.presenters.EditCurriculumMediator;
	import net.poweru.presenters.EditEnrollmentsMediator;
	import net.poweru.presenters.EditEventMediator;
	import net.poweru.presenters.EditEventTemplateMediator;
	import net.poweru.presenters.EditExamMediator;
	import net.poweru.presenters.EditFileDownloadMediator;
	import net.poweru.presenters.EditGroupMediator;
	import net.poweru.presenters.EditMessageTemplateMediator;
	import net.poweru.presenters.EditOrganizationMediator;
	import net.poweru.presenters.EditRoomMediator;
	import net.poweru.presenters.EditSessionMediator;
	import net.poweru.presenters.EditSessionTemplateMediator;
	import net.poweru.presenters.EditSessionUserRoleMediator;
	import net.poweru.presenters.EditSessionUserRoleRequirementMediator;
	import net.poweru.presenters.EditTaskBundleMediator;
	import net.poweru.presenters.EditUserMediator;
	import net.poweru.presenters.EditUserOrgRoleMediator;
	import net.poweru.presenters.EditVenueMediator;
	import net.poweru.presenters.EventTemplatesMediator;
	import net.poweru.presenters.EventsMediator;
	import net.poweru.presenters.ExamsMediator;
	import net.poweru.presenters.FileDownloadsMediator;
	import net.poweru.presenters.GroupsMediator;
	import net.poweru.presenters.LoginMediator;
	import net.poweru.presenters.MessageTemplatesMediator;
	import net.poweru.presenters.OrgUploadCSVMediator;
	import net.poweru.presenters.OrganizationsMediator;
	import net.poweru.presenters.ResetPasswordMediator;
	import net.poweru.presenters.SelfRegisterMediator;
	import net.poweru.presenters.SessionUserRolesMediator;
	import net.poweru.presenters.TaskBundlesMediator;
	import net.poweru.presenters.TranscriptMediator;
	import net.poweru.presenters.UploadFileDownloadMediator;
	import net.poweru.presenters.UserManagementMediator;
	import net.poweru.presenters.UserUploadCSVMediator;
	import net.poweru.presenters.UsersMediator;
	import net.poweru.presenters.VenuesMediator;
	import net.poweru.presenters.ViewExamAssignmentsMediator;
	import net.poweru.presenters.ViewFileDownloadAssignmentsMediator;
	import net.poweru.presenters.student.AssignmentsMediator;
	import net.poweru.presenters.student.CurriculumEnrollmentMediator;
	import net.poweru.presenters.student.ExamAssignmentsMediator;
	import net.poweru.presenters.student.FileDownloadAssignmentsMediator;
	import net.poweru.presenters.student.SessionAssignmentMediator;

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
				case Places.ACHIEVEMENTS:
					component = getOrCreate(name, Achievements, AchievementsMediator);
					break;
				
				case Places.ADDTASKSTOCURRICULUM:
					component = getOrCreate(name, AddTasksToCurriculum, AddTasksToCurriculumMediator);
					break;
				
				case Places.ADMIN:
					component = getOrCreate(name, Admin, AdminMediator);
					break;
				
				case Places.ADMINISTEREXAMSESSION:
					component = getOrCreate(name, AdministerExamSession, AdministerExamSessionMediator);
					break;
				
				case Places.ASSIGNMENTS:
					component = getOrCreate(name, Assignments, net.poweru.presenters.AssignmentsMediator);
					break;
				
				case Places.BULKASSIGNMENTRESULTS:
					component = getOrCreate(name, BulkAssignmentResults, BulkAssignmentResultsMediator);
					break;
				
				case Places.BULKENROLLINEVENT:
					component = getOrCreate(name, BulkEnrollInEvent, BulkEnrollInEventMediator);
					break;
				
				case Places.CHOOSEACHIEVEMENT:
					component = getOrCreate(name, ChooseAchievement, ChooseAchievementMediator);
					break;
				
				case Places.CHOOSEEXAM:
					component = getOrCreate(name, ChooseExam, ChooseExamMediator);
					break;
				
				case Places.CHOOSEFILEDOWNLOAD:
					component = getOrCreate(name, ChooseFileDownload, ChooseFileDownloadMediator);
					break;
				
				case Places.CHOOSEGROUP:
					component = getOrCreate(name, ChooseGroup, ChooseGroupMediator);
					break;
				
				case Places.CHOOSEORGANIZATION:
					component = getOrCreate(name, ChooseOrganization, ChooseOrganizationMediator);
					break;
				
				case Places.CHOOSEORGROLE:
					component = getOrCreate(name, ChooseOrgRole, ChooseOrgRoleMediator);
					break;
				
				case Places.CHOOSEROOM:
					component = getOrCreate(name, ChooseRoom, ChooseRoomMediator);
					break;
				
				case Places.CHOOSETASK:
					component = getOrCreate(name, ChooseTask, ChooseTaskMediator);
					break;
				
				case Places.CHOOSETASKBUNDLE:
					component = getOrCreate(name, ChooseTaskBundle, ChooseTaskBundleMediator);
					break;
				
				case Places.CHOOSEUSER:
					component = getOrCreate(name, ChooseUser, ChooseUserMediator);
					break;
				
				case Places.CHOOSEUSERSTATUS:
					component = getOrCreate(name, ChooseUserStatus, ChooseUserStatusMediator);
					break;
				
				case Places.CONFIRMLOGOUT:
					component = getOrCreate(name, ConfirmLogout, ConfirmLogoutMediator);
					break;
				
				case Places.CREATEACHIEVEMENT:
					component = getOrCreate(name, CreateAchievement, CreateAchievementMediator);
					break;
				
				case Places.CREATEBLACKOUTPERIOD:
					component = getOrCreate(name, CreateBlackoutPeriod, CreateBlackoutPeriodMediator);
					break;
				
				case Places.CREATECREDENTIALTYPE:
					component = getOrCreate(name, CreateCredentialType, CreateCredentialTypeMediator);
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
				
				case Places.CREATESESSIONUSERROLEREQUIREMENT:
					component = getOrCreate(name, CreateSessionUserRoleRequirement, CreateSessionUserRoleRequirementMediator);
					break;
				
				case Places.CREATETASKBUNDLE:
					component = getOrCreate(name, CreateTaskBundle, CreateTaskBundleMediator);
					break;
				
				case Places.CREATETASKFEE:
					component = getOrCreate(name, CreateTaskFee, CreateTaskFeeMediator);
					break;
				
				case Places.CREATEUSER:
					component = getOrCreate(name, CreateUser, CreateUserMediator);
					break;
				
				case Places.CREATEVENUE:
					component = getOrCreate(name, CreateVenue, CreateVenueMediator);
					break;
				
				case Places.CREDENTIALMANAGEMENT:
					component = getOrCreate(name, CredentialManagement, CredentialManagementMediator);
					break;
				
				case Places.CREDENTIALTYPES:
					component = getOrCreate(name, CredentialTypes, CredentialTypesMediator);
					break;
				
				case Places.CURRICULUMENROLLMENTS:
					component = getOrCreate(name, net.poweru.components.CurriculumEnrollments, net.poweru.presenters.CurriculumEnrollmentMediator);
					break;
				
				case Places.CURRICULUMMANAGEMENT:
					component = getOrCreate(name, CurriculumManagement, CurriculumManagementMediator);
					break;
				
				case Places.CURRICULUMS:
					component = getOrCreate(name, Curriculums, CurriculumsMediator);
					break;
				
				case Places.EDITACHIEVEMENT:
					component = getOrCreate(name, EditAchievement, EditAchievementMediator);
					break;
				
				case Places.EDITASSIGNMENT:
					component = getOrCreate(name, EditAssignment, EditAssignmentMediator);
					break;
				
				case Places.EDITBLACKOUTPERIOD:
					component = getOrCreate(name, EditBlackoutPeriod, EditBlackoutPeriodMediator);
					break;
				
				case Places.EDITCREDENTIALTYPE:
					component = getOrCreate(name, EditCredentialType, EditCredentialTypeMediator);
					break;
				
				case Places.EDITCURRICULUM:
					component = getOrCreate(name, EditCurriculum, EditCurriculumMediator);
					break;
				
				case Places.EDITCURRICULUMENROLLMENT:
					component = getOrCreate(name, EditCurriculumEnrollment, EditCurriculumEnrollmentMediator);
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
				
				case Places.EDITMESSAGETEMPLATE:
					component = getOrCreate(name, EditMessageTemplate, EditMessageTemplateMediator);
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
				
				case Places.EDITSESSIONUSERROLEREQUIREMENT:
					component = getOrCreate(name, EditSessionUserRoleRequirement, EditSessionUserRoleRequirementMediator);
					break;
				
				case Places.EDITTASKBUNDLE:
					component = getOrCreate(name, EditTaskBundle, EditTaskBundleMediator);
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
				
				case Places.IMPORTORGANIZATIONS:
					component = getOrCreate(name, UploadCSV, OrgUploadCSVMediator);
					break;
				
				case Places.IMPORTUSERS:
					component = getOrCreate(name, UploadCSV, UserUploadCSVMediator);
					break;
				
				case Places.LOGIN:
					component = getOrCreate(name, Login, LoginMediator);
					break;
				
				case Places.MESSAGETEMPLATES:
					component = getOrCreate(name, MessageTemplates, MessageTemplatesMediator);
					break;
				
				case Places.NO_ORG_USER:
					component = getOrCreate(name, NoOrgUser);
					break;
					
				case Places.ORGANIZATIONS:
					component = getOrCreate(name, Organizations, OrganizationsMediator);
					break;
				
				case Places.PENDING_USER:
					component = getOrCreate(name, PendingUser);
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
					component = getOrCreate(name, AssignmentsTab, net.poweru.presenters.student.AssignmentsMediator);
					break;
				
				case Places.STUDENTCURRICULUMENROLLMENTS:
					component = getOrCreate(name, net.poweru.components.student.CurriculumEnrollments, net.poweru.presenters.student.CurriculumEnrollmentMediator);
					break;
				
				case Places.TASKBUNDLES:
					component = getOrCreate(name, TaskBundles, TaskBundlesMediator);
					break;
				
				case Places.TRANSCRIPT:
					component = getOrCreate(name, Transcript, TranscriptMediator);
					break;
				
				case Places.UPLOADFILEDOWNLOAD:
					component = getOrCreate(name, UploadFileDownload, UploadFileDownloadMediator);
					break;
				
				case Places.USERMANAGEMENT:
					component = getOrCreate(name, UserManagement, UserManagementMediator);
					break;
				
				case Places.USERS:
					component = getOrCreate(name, Users, UsersMediator);
					break;
				
				case Places.VENUES:
					component = getOrCreate(name, Venues, VenuesMediator);
					break;
				
				case Places.VIEWEXAMASSIGNMENTS:
					component = getOrCreate(name, ViewExamAssignments, ViewExamAssignmentsMediator);
					break;
				
				case Places.VIEWFILEDOWNLOADASSIGNMENTS:
					component = getOrCreate(name, ViewFileDownloadAssignments, ViewFileDownloadAssignmentsMediator);
					break;
				
				default:
					component = super.getComponent(name);
			}
			
			return component;
		}
		
	}
}