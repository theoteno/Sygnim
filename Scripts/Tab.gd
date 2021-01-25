extends Tabs
class_name Tab

var file_path : String  = ""
var file_name : String  = "Untitled"
var file_type : String  = "Text"
var tab_ready : bool    = false

onready var text_edit_box = get_node("TextEdit")
onready var editor = get_parent().get_parent()

enum ERRORS {
    ALL_OK, TAB_NOT_READY, FILE_NOT_EXIST,
    DIRECTORY_NOT_EXIST, FAILED
}


func _ready():
    # add_to_group("Tabs")
    #Connect resize signal
    editor.connect("resized", self, "_on_Editor_resized")
    #initial resize
    _on_Editor_resized()
    tab_ready = true
    SignumSettings.applySettingsToTab(self)
    ThemeManager.applySyntaxToTab(self)
    

func loadFromFile(path : String) -> int:
    if not tab_ready:
        return ERRORS.TAB_NOT_READY

    var file = File.new()
    if not file.file_exists(path):
        print("Failed to open %s" % [path])
        return ERRORS.FILE_NOT_EXIST
    
    file.open(path, 1)
    text_edit_box.text = file.get_as_text()
    _setFileDetails(path)
    file.close()
    return ERRORS.ALL_OK


func renameFile(new_name : String):
    var base_dir = new_name.get_base_dir()
    if base_dir != "":
        file_path = new_name
        file_name = new_name.get_file()
    else:
        file_path = file_path.get_base_dir() + "/" + new_name
        file_name = new_name
    print("New name %s new path %s" % [file_name, file_path])


func saveFile():
    var file = File.new()
    var err = file.open(file_path, 2)
    if err == OK:
        file.store_string(text_edit_box.text)
    else: 
        print("Failed to save file " + file_path)
    file.close()

#Manual resizing of tab
func _on_Editor_resized():
    rect_size = Vector2(editor.rect_size.x, editor.rect_size.y - margin_top)


func _setFileDetails(path):
    file_path = path
    var file_extension = file_path.get_extension()
    if file_extension == "" or file_extension == "txt":
        file_type = "Text"
    elif file_extension == "gd":
        file_type = "GDscript"