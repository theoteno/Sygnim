extends Control

# Tab scene resource
var tab_scene = preload("res://Scenes/Tab.tscn")
const UNTITLED = 'Untitled'

# Reference to current working tab
var current_tab = null
var current_file = UNTITLED
var max_recents = 10

onready var save_as_file_dialog = get_node('SaveAsFileDialog')
onready var open_file_dialog = get_node('OpenFileDialog')
onready var about_popup = get_node('AboutPopup')
onready var tab_container = get_node("HSplitContainer/Tabs/TabContainer")


func _ready():
	updateWindowTitle()
	restorePreviousSession()
	

func _process(_delta: float) -> void:
	#adding typewriter like window movement..
	if Input.is_key_pressed(KEY_ALT) && Input.is_key_pressed(KEY_R):
		if not OS.window_position == Vector2(171, 84):
			OS.window_position = Vector2(171, 84)
	if Input.is_key_pressed(KEY_SPACE):
		OS.window_position.x += 1
	if Input.is_key_pressed(KEY_BACKSPACE):
		OS.window_position.x -= 1
	if Input.is_key_pressed(KEY_ENTER):
		#print(OS.window_position)
		OS.window_position.y += 1
		if not OS.window_position.x == 171:
			OS.window_position.x = 171
		else: pass

func restorePreviousSession():
	if SignumSettings.settings.last_opened_files.size() != 0:
		# Open previously opened files
		for i in SignumSettings.settings.last_opened_files:
			newTab(i)
	else:
		newTab()

#Update title
func updateWindowTitle():
	OS.set_window_title('Signum - ' + current_file)
	

# File Menu IDs:
# Open File = 0
# Save As File = 1
# Save File = 4
# Quit = 2
# New File = 3
# ----------------
# Help Menu IDs:
# About = 0
# Github Page = 1
# Github Issues = 2



func newTab(path : String = UNTITLED):
	if path == UNTITLED:
		path = _getAvailableUntitledFileName()
	if isFileOpen(path):
		switchToTab(path)
		return

	var new_tab = tab_scene.instance()
	tab_container.add_child(new_tab)
	tab_container.add_tab(path.get_file())
	new_tab.loadFromFile(path)
	var tab_id =  tab_container.get_child_count() - 1
	tab_container.current_tab = tab_id


func _getAvailableUntitledFileName() -> String:
	var file_name : String = UNTITLED
	var count = 1
	while (isFileOpen(file_name)):
		file_name = file_name + count.to_string()
		count += 1
	return file_name
	

# Check if File is open in editor
func isFileOpen(file_path : String) -> bool:
	var tabs = tab_container.get_children()
	for i in tabs:
		if i.file_path == file_path:
			return true
	return false


# Switch to tab with given file path
func switchToTab(file_path : String):
	var tabs = tab_container.get_children()
	var id = 0
	for i in tabs:
		if i.file_path == file_path:
			current_tab = i
			tab_container.current_tab = id
		id += 1


#Tab changed
func _on_TabContainer_tab_changed(tab_id):
	var tabs = tab_container.get_children()
	current_tab = tab_container.get_child(tab_id)
	#Hide all tabs
	for i in tabs:
		i.hide()
	
	#Show current tab
	current_tab.show()


# Handle tab repositioning ( Called when user moves tabs)
func _on_TabContainer_reposition_active_tab_request(idx_to):
	var idx_from = tab_container.current_tab
	var tc = tab_container
	
	#Tab moved left to right
	if idx_to > idx_from:
		#re-arrange children
		for i in range(idx_from + 1, idx_to + 1):
			tc.move_child(tc.get_child(i),i - 1)
	
	#Tab moved right to left
	else:
		#re-arrange children
		for i in range(idx_from - 1, idx_to - 1, -1):
			tc.move_child(tc.get_child(i),i + 1)


# Handle tab close
func _on_TabContainer_tab_close(tab_id): 
	# If Only 1 file is open, create new untitled file
	if tab_container.get_tab_count() == 1:
		newTab()
	
	#If first tab then switch to next tab
	if tab_id == 0:
		_on_TabContainer_tab_changed(tab_id + 1)
	# Switch to previous tab
	else:
		_on_TabContainer_tab_changed(tab_id - 1)
	# Remove tab
	tab_container.get_child(tab_id).queue_free()
	tab_container.remove_tab(tab_id)
