extends Tabs

#Path to file
var file_path : String = "Untitled"

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
