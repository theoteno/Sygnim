extends Tree

# icons, need more icons for various file types
var icons = {
	folder = preload("res://Resources/icons/icons8-folder-26.png"),
	gd = preload("res://Resources/icons/icons8-gear-26.png"),
	txt = preload("res://Resources/icons/icons8-txt-26.png")
}

# Current directory
var base_dir = ""
# Tree item root
var root_dir = null

func _ready():
	# Get File selector and connect file selection signal
	var fileselector : FileDialog = get_tree().get_nodes_in_group("FileSelector")[0]
	fileselector.connect("file_selected", self, "_on_file_selected")
	# Load current folder, if exist
	if GlobalData.settings.last_opened_files.size() > 0:
		var count = GlobalData.settings.last_opened_files.size()
		var cur_file = GlobalData.settings.last_opened_files[count - 1]
		setup_dir(cur_file.get_base_dir())

# Load directory of file selected by "file selector" (present in main)
func _on_file_selected(file_path : String):
	var dir_path = file_path.get_base_dir()
	setup_dir(dir_path)

# Get name of directory
func get_directory_name(dir_path : String) -> String:
	var strings = dir_path.split("/")
	if strings.size() > 0:
		return strings[strings.size() - 1]
	return "/"


# Setup ...
func setup_dir(dir_path : String):
	# Clear prev listing
	if root_dir != null:
		yield(get_tree(), "idle_frame")
		root_dir.free()
	
	base_dir = dir_path
	var dir = Directory.new()
	var dir_list = []
	var files = []
	dir.open(dir_path)
	dir.list_dir_begin()
	
	var file_name = dir.get_next()
	root_dir = create_item()
	root_dir.set_text(0, get_directory_name(dir_path) + "/")
	# Get dir contents
	while file_name != "":
		if file_name != ".":
			if dir.current_is_dir():
				dir_list.append(file_name)
			else:
				files.append(file_name)
		file_name = dir.get_next()
	
	# Sort them
	dir_list.sort()
	files.sort()
	
	for i in dir_list:
		var item = create_item(root_dir)
		item.set_text(0, i)
		item.set_icon(0, icons.folder)
	
	for i in files:
		var item = create_item(root_dir)
		item.set_text(0, i)
		var ext = i.get_extension()
		# Set appropriate icon if exists
		if icons.has(ext):
			item.set_icon(0, icons.get(ext))
		else:
			item.set_icon(0, icons.txt)


func _on_Tree_item_selected():
	var selected_file = get_selected().get_text(0)
	# If go up selected
	if selected_file == "..":
		var path = base_dir.get_base_dir()
		setup_dir(path)
	elif selected_file != root_dir.get_text(0):
		var path = base_dir + "/" + selected_file
		var file : File = File.new()
		# Chk file is folder or directory
		if file.file_exists(path):
			var main_scene = get_tree().get_nodes_in_group("Main")[0]
			main_scene.open_file_selected(path)
		else:
			setup_dir(path)


