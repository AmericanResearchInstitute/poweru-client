package net.poweru.components.dialogs.code
{
	import com.hillelcoren.components.autoComplete.classes.IconButton;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.containers.Accordion;
	import mx.containers.VBox;
	import mx.controls.DateField;
	import mx.controls.TextArea;
	import mx.controls.TextInput;
	import mx.core.IContainer;
	import mx.events.FlexEvent;
	import mx.events.IndexChangedEvent;
	import mx.validators.Validator;
	
	import net.poweru.Places;
	import net.poweru.components.dialogs.BaseCRUDDialog;
	import net.poweru.components.dialogs.CreateSession;
	import net.poweru.components.interfaces.ICreateDialog;
	import net.poweru.components.interfaces.ICreateEventFromTemplateDialog;
	import net.poweru.components.widgets.CreateSessionFromTemplate;
	import net.poweru.generated.model.Event.NameInput;
	import net.poweru.generated.model.Event.TitleInput;
	import net.poweru.model.ChooserResult;
	import net.poweru.model.DataSet;
	
	public class CreateEventFromTemplateCode extends BaseCRUDDialog implements ICreateEventFromTemplateDialog
	{
		public var nameInput:NameInput;
		public var titleInput:TitleInput;
		public var leadTimeInput:TextInput;
		[Bindable]
		public var startInput:DateField;
		[Bindable]
		public var endInput:DateField;
		public var descriptionInput:TextArea;
		public var extraValidators:Array;
		public var createSessionWidgets:Accordion;
		public var createSessionWidgetStartupBox:VBox;
		
		[Bindable]
		protected var chosenOrganization:Object;
		protected var eventTemplate:Object;
		protected var sessionTemplates:Array;
		protected var sortedSessionTemplates:DataSet;
		
		protected var widgetValidators:Array = [];
		
		public function CreateEventFromTemplateCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			
			sortedSessionTemplates = new DataSet();
			var sort:Sort = new Sort();
			sort.fields = [new SortField('sequence',false, false, true)];
			sortedSessionTemplates.sort = sort;
		}
		
		override public function get validators():Array
		{
			return super.validators.concat(widgetValidators);
		}
		
		override public function getData():Object
		{
			var sessions:Array = [];
			for each (var widget:CreateSessionFromTemplate in createSessionWidgetStartupBox.getChildren())
			{
				var session:Object = widget.getData();
				if (session.hasOwnProperty('event'))
					delete session.event;
				var optionalAttributes:Object = {};
				for each (var attr:String in ['title', 'url', 'description', 'lead_time'])
				{
					if (session.hasOwnProperty(attr))
					{
						optionalAttributes[attr] = session[attr];
						delete session[attr];
					}
				}
				session['optional_attributes'] = optionalAttributes;
				sessions.push(session);
			}
			
			return {
				'name' : nameInput.text,
				'title' : titleInput.text,
				'lead_time' : leadTimeInput.text,
				'description' : descriptionInput.text,
				'start' : startInput.selectedDate,
				'end' : endInput.selectedDate,
				'organization' : chosenOrganization.id,
				'sessions' : sessions
			};
		}
		
		override public function clear():void
		{
			nameInput.text = '';
			titleInput.text = '';
			leadTimeInput.text = '';
			descriptionInput.text = '';
			startInput.selectedDate = null;
			endInput.selectedDate = null;
			createSessionWidgets.removeAllChildren();
		}
		
		public function populate(eventTemplate:Object, sessionTemplates:Array):void
		{
			clear();
			this.eventTemplate = eventTemplate;
			this.sessionTemplates = sessionTemplates;
			applyTemplateValues();
			sortedSessionTemplates.source = sessionTemplates;
			sortedSessionTemplates.refresh();
		}
		
		protected function applyTemplateValues():void
		{
			if (eventTemplate != null && sessionTemplates != null)
			{
				descriptionInput.text = eventTemplate['description'];
				nameInput.text = eventTemplate['name_prefix'];
				titleInput.text = eventTemplate['title'];
				leadTimeInput.text = eventTemplate['lead_time'];
				
				widgetValidators = [];
				createSessionWidgets.removeAllChildren();
				addCreateSessionWidgets();
			}
		}
		
		protected function addCreateSessionWidgets():void
		{
			if (sessionTemplates != null)
			{
				var count:int = 1;
				
				for each (var template:Object in sessionTemplates)
				{
					var widget:CreateSessionFromTemplate = new CreateSessionFromTemplate();
					widget.addEventListener(FlexEvent.CREATION_COMPLETE, onCreateSessionWidgetCreationComplete);
					createSessionWidgetStartupBox.addChild(widget);
					
					/*	the widget will handle populating it's controls once
						creation is complete. */
					widget.sessionTemplate = template;
					
					// create a container in the accordion for each template
					var box:VBox = new VBox;
					box.label = 'Session ' + String(count);
					createSessionWidgets.addChild(box);
					count++;
				}
			}
		}
		
		override public function receiveChoice(choice:ChooserResult, chooserName:String):void
		{
			if (chooserName == Places.CHOOSEORGANIZATION && chooserRequestTracker.doIWantThis(chooserName, choice.requestID))
				chosenOrganization = choice.value;
		}
		
		protected function onCreateSessionWidgetCreationComplete(event:FlexEvent):void
		{
			var widget:CreateSessionFromTemplate = event.target as CreateSessionFromTemplate;
			widget.removeEventListener(FlexEvent.CREATION_COMPLETE, onCreateSessionWidgetCreationComplete);
			widgetValidators.concat(widget.validators);
			
			/*	get the index based on the sorted collection (sorting on sequence number),
				and add the form to the appropriate container. */
			var index:int = sortedSessionTemplates.getItemIndex(sortedSessionTemplates.findByPK(widget.sessionTemplate['id']));
			var container:IContainer = createSessionWidgets.getChildAt(index) as IContainer;
			container.addChild(widget.createForm);
		}
		
		protected function onStartDateChosen(event:Event):void
		{
			// subtract one day
			endInput.disabledRanges = [{'rangeEnd': new Date(startInput.selectedDate.getTime() - 1000*60*60*24)}];
			
			// if the newly chosen start date is after the end date, erase the end date so the user must choose a new one
			if (endInput.selectedDate != null && endInput.selectedDate.getTime() < startInput.selectedDate.getTime())
				endInput.selectedDate = null;
			if (endInput.selectedDate != null)
				populateEventDates();
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			focusManager.setFocus(nameInput);
			
			validators = [
				nameInput.validator,
				titleInput.validator,
			];
			for each (var validator:Validator in extraValidators)
			validators.push(validator);
		}
		
		protected function onEndDateSelected(event:Event):void
		{
			populateEventDates();
		}
		
		// This gives each widget the data it needs to validate its own dates
		protected function populateEventDates():void
		{
			for each (var widget:CreateSessionFromTemplate in createSessionWidgetStartupBox.getChildren())
			{
				widget.populateEventData({
					'start' : startInput.selectedDate,
					'end' : endInput.selectedDate
				});
			}
		}
	}
}