extends Tabs

#Path to file
var file_path : String = "Untitled"  setget set_file_path

var file_type = "Text"

#NOTE : Tab does not resize automatically when resized, manual resizing is required.
#REASON : we don't want to auto-resize `TabContainer` (Parent of this tab)
#		  but this tab must resize when window size is changed. To fix this,
#		  We will change size of this tab according to parent of `TabContainer`
onready var editor = get_parent().get_parent()

func _ready():
	#Connect resize signal
	editor.connect("resized", self, "_on_Editor_resized")
	#initial resize
	_on_Editor_resized()
	


#Manual resizing of tab
func _on_Editor_resized():
	rect_size = Vector2(editor.rect_size.x, editor.rect_size.y - margin_top)


func set_file_path(fpath):
	file_path = fpath
	var file_extension = file_path.get_extension()
	
	if file_extension == "" or file_extension == "txt":
		file_type = "Text"
		
	
	elif file_extension == "gd":
		file_type = "GDscript"
		
	print(file_type)
