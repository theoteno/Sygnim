extends Tree

# icons, need more icons for various file types
var icons = {
    folder  = preload("res://Resources/icons/icons8-folder-26.png"),
    gd      = preload("res://Resources/icons/icons8-gear-26.png"),
    txt     = preload("res://Resources/icons/icons8-txt-26.png")
}

# Current directory
var current_dir = ""
# Tree item root
var root_dir = null

func _ready():
    # Get File selector and connect file selection signal
    var fileselector : FileDialog = get_tree().get_nodes_in_group("FileSelector")[0]
    var err = fileselector.connect("file_selected", self, "_on_file_selected")
    if err != OK:
        print("Failed to connect signal _on_file_selected")
    _openPreviouslyOpenedDirectory()


# Setup ...
func openDirectory(dir_path : String):
    if root_dir != null:
        # Clear prev listing
        yield(get_tree(), "idle_frame")
        root_dir.free()
    
    current_dir = dir_path
    var dir = Directory.new()
    var dir_list = []
    var files = []
    var file_name = ""

    dir.open(dir_path)
    dir.list_dir_begin()
    file_name = dir.get_next()
    root_dir = create_item()
    root_dir.set_text(0, dir_path.get_base_dir() + "/")
    # Get dir contents
    while file_name != "":
        if file_name != ".":
            if dir.current_is_dir():
                dir_list.append(file_name)
            else:
                files.append(file_name)
        file_name = dir.get_next()
    
    _showDirs(dir_list)
    _showFiles(files)
    

func _openPreviouslyOpenedDirectory():
    if SignumSettings.settings.last_opened_files.size() > 0:
        var count = SignumSettings.settings.last_opened_files.size()
        var cur_file : String = SignumSettings.settings.last_opened_files[count - 1]
        openDirectory(cur_file.get_base_dir())


func _showDirs(dir_list : Array):
    dir_list.sort()
    for i in dir_list:
        var item = create_item(root_dir)
        item.set_text(0, i)
        item.set_icon(0, icons.folder)


func _showFiles(files : Array):
    files.sort()
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
        var path = current_dir.get_base_dir()
        openDirectory(path)
    elif selected_file != root_dir.get_text(0):
        var path = current_dir + "/" + selected_file
        var file : File = File.new()
        # Chk file is folder or directory
        if file.file_exists(path):
            var editor = get_tree().get_nodes_in_group("Editor")[0]
            editor.newTab(path)
        else:
            openDirectory(path)


# Load directory of file selected by "file selector" (present in main)
func _on_file_selected(file_path : String):
    openDirectory(file_path.get_base_dir())
