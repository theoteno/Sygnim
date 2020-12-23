extends OptionButton

# Theme array
export var themes = [
	"res://Themes/godot_theme.tres",
	"res://Themes/solarized_theme.tres",
	"res://Themes/clean_slate_theme.tres"
]

func _ready():
	add_item("Godot", 0)
	add_item("Solarized", 1)
	add_item("Clean Slate", 2)
	
	#set selected theme in option Button
	selected = GlobalData.settings.selected_theme_id
	
	#Apply selected theme
	theme_select(GlobalData.settings.selected_theme_id)

#Function to apply theme
func theme_select(id):
	get_tree().root.get_child(1).theme = load(themes[id])
	if get_tree().root.get_child(1).theme == load(themes[2]):
		get_node('/root/Main/ColorRect').color = Color('#ffffff')
	if get_tree().root.get_child(1).theme == load(themes[1]):
		get_node('/root/Main/ColorRect').color = Color('#dcd2bb')
	if get_tree().root.get_child(1).theme == load(themes[0]):
		get_node('/root/Main/ColorRect').color = Color('#191a2f')
	
	#set selected theme id in global settings
	GlobalData.settings.selected_theme_id = id
