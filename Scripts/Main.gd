extends Control

onready var save_as_file_dialog = get_node('SaveAsFileDialog')
onready var open_file_dialog = get_node('OpenFileDialog')
onready var about_popup = get_node('AboutPopup')
onready var text_editor = get_node('HSplitContainer/TextEdit')

const UNTITLED = 'Untitled'
var current_file = UNTITLED
var max_recents = 10

func _ready():
	title_update()

func title_update():
	# This sets the title for the current title
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

func file_item_pressed(id):
	match id:
		0:
			# Opens file select dialog
			open_file_dialog.popup()
		1:
			# Opens save file dialog
			save_as_file_dialog.popup()
		2:
			# Closes the program
			get_tree().quit()
		3:
			# Creates file
			new_file()
		4:
			# Saves file without changing the name
			save_file()

func help_item_pressed(id):
	match id:
		0:
			# Opens about popup
			about_popup.popup()
		1:
			# Opens the github page in the browser
			OS.shell_open('https://github.com/MintStudios/Signum')
		2:
			# Opens issues in github
			OS.shell_open('https://github.com/MintStudios/Signum/issues')

# Creates a new file
func new_file():
	current_file = UNTITLED
	title_update()
	# Resets the text back to nothing
	text_editor.text = ''

# Opens an existing file
func open_file_selected(path):
	# Creates and reads the file
	var file = File.new()
	file.open(path, 1)
	# Makes the TextEdit text the same as the file's
	text_editor.text = file.get_as_text()
	# Closes to prevent memory leaks
	file.close()
	# Changes the title to the file path
	current_file = path
	title_update()
	# Checks if the recents list exceeds 10, if not, continues.
	if $HSplitContainer/Sidebar/Recents/Recents.get_child_count() < max_recents:
		# Creates button for recent files
		var button = Button.new()
		button.focus_mode = Control.FOCUS_NONE
		$HSplitContainer/Sidebar/Recents/Recents.add_child(button)
		button.text = path.get_file()
		# Signal to go to the recent file
		button.connect("pressed", self, "go_to_recent", [path])

# Saves the file as a file type
func save_as_file_selected(path):
	# Creates and writes the file
	var file = File.new()
	file.open(path, 2)
	file.store_string(text_editor.text)
	# Closes to prevent memory leaks
	file.close()
	# Changes the title to the file path
	current_file = path
	title_update()

func save_file():
	# Changes the title to the file path
	var path = current_file
	# Checks if the file hasn't been created. If it has, then it triggers the 'Save As` Dialog
	if path == UNTITLED:
		save_as_file_dialog.popup()
	# If the file exists, writes the file.
	else:
		var file = File.new()
		file.open(path, 2)
		file.store_string(text_editor.text)
		# Closes to prevent memory leaks
		file.close()
		# Changes the title to the file path
		current_file = path

# Signal for going to the recent file
func go_to_recent(path):
	# Creates and reads the file
	var file = File.new()
	file.open(path, 1)
	# Makes the TextEdit text the same as the file's
	text_editor.text = file.get_as_text()
	# Closes to prevent memory leaks
	file.close()
	# Changes the title to the file path
	current_file = path
	title_update()

# Clears the recents list
func clear_recents():
	for rcnt in $HSplitContainer/Sidebar/Recents/Recents.get_children():
		# Deletes itself
		rcnt.queue_free()
