extends OptionButton

export var themes = [
	"res://Themes/godot_theme.tres",
	"res://Themes/solarized_theme.tres"
]

func _ready():
	add_item("Godot", 0)
	add_item("Solarized", 1)

	get_tree().root.get_child(1).theme = load(themes[0])

func theme_select(id):
	return
	get_tree().root.get_child(1).theme = load(themes[id])
	if get_tree().root.get_child(1).theme == load(themes[1]):
		get_node('/root/Main/ColorRect').color = Color('#dcd2bb')
	if get_tree().root.get_child(1).theme == load(themes[0]):
		get_node('/root/Main/ColorRect').color = Color('#191a2f')
