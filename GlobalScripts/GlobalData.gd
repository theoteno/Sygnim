extends Node

#place where settings are stored
const settings_path = "user://settings.dat"

#Editor settings with default settings
var settings = {
	draw_tabs = true,
	draw_spaces = false,
	highlight_current_line = true,
	caret_block_mode = false,
	show_line_numbers = true,
	selected_theme_id = 0,
	
	#Last opened files
	last_opened_files = []
}


#Apply settings to opened tabs
func apply_settings_to_opened_tabs():
	#Get Tab container
	var tab_container = get_node('/root/Main/HSplitContainer/TabContainer')
	
	if tab_container:
		var tabs = tab_container.get_children()
		
		#Apply settings to all tabs
		for i in tabs:
			apply_settings_to_tab(i)


#Apply editor settings to the tab
func apply_settings_to_tab(Tab):
	var text_edit : TextEdit = Tab.get_node("TextEdit")
	text_edit.draw_tabs = settings.draw_tabs
	text_edit.draw_spaces = settings.draw_spaces
	text_edit.highlight_current_line = settings.highlight_current_line
	text_edit.caret_block_mode = settings.caret_block_mode
	text_edit.show_line_numbers = settings.show_line_numbers


#Save Dictionary in a file
func save_data(save_path : String, data : Dictionary):
	var data_string = JSON.print(data)
	var file = File.new()
	var json_error = validate_json(data_string)
	
	#Oops invalid Dictionary
	if json_error:
		print("Error : unable to save %s" % [save_path])
		print_debug("JSON IS NOT VALID FOR: " + data_string)
		print_debug("error: " + json_error)
		return
	
	#open and save data
	file.open(save_path,File.WRITE)
	file.store_string(data_string)
	file.close()


#Load data from File, returns dictionary if success otherwise will
#return null 
func load_data(save_path : String):
	var file : File = File.new()
	
	#File does not exist
	if not file.file_exists(save_path):
		print_debug('file [%s] does not exist' % save_path)
		return null
	
	#Load and return data
	file.open(save_path,File.READ)
	var json : String = file.get_as_text()
	var data = parse_json(json)
	file.close()
	return data


#Copy dictionary drom source to destination dictionary
func cpy_dictionary(dest_D : Dictionary, src_D : Dictionary):
	var keys = src_D.keys()
	for i in keys:
		if dest_D.has(i):
			dest_D[i] = src_D[i]


func _ready():
	var settings_dict = load_data(settings_path)
	
	#File do not exist, So create new file with default settings
	if not settings_dict:
		print("Running for the first time.....")
		#create file with default settings
		save_data(settings_path, settings)
		return
	
	#copy settings that we have loaded from file to settings 
	#we can also use settings = settings_dict but its unsafe
	cpy_dictionary(settings, settings_dict)
	

#Handle quit, As we need to save settings before we close the program
func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		_on_exit()
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		_on_exit()
		


func _on_exit():
	print("saving .....")
	#Save list of opended files
	saveSession()
	#save settings
	save_data(settings_path, settings)
	#quit/stop program
	get_tree().quit(0)

#This function adds opened files to "settings.last_opened_files"
func saveSession():
	#Clear list
	GlobalData.settings.last_opened_files.clear()
	#Get opened tabs
	var tabs = get_tree().get_nodes_in_group("Tabs")
	#Append opened files
	for i in tabs:
		#Exclude Untitled files
		if i.file_path != 'Untitled':
			settings.last_opened_files.append(i.file_path)

