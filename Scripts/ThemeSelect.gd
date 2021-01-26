extends OptionButton

func _ready():
    selected = _getThemeId(SignumSettings.settings.theme)
    _loadItems()


func _loadItems():
    var themes = ThemeManager.themes.keys()
    var id = 0
    for i in themes:
        add_item(i, id)
        id += 1


# Function to apply theme
func theme_select(id):
    ThemeManager.loadTheme(get_item_text(id))
    

func _getThemeId(theme_name : String) -> int:
    var count = get_item_count()
    for i in range(count):
        if get_item_text(i) == theme_name:
            return i
    return 0
