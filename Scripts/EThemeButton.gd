extends OptionButton


func _ready():
	add_item("Default", 0)
	add_item("Atom Dark", 1)
	add_item("Monokai", 2)
	
	selected = GlobalData.settings.current_syntax_theme_id

func _on_EThemeButton_item_selected(index):
	GlobalData.load_syntax_theme(index)
	GlobalData.apply_syntax_theme_to_opened_tabs()
