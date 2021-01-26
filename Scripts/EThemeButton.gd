extends OptionButton

func _ready():
    _loadItems()
    selected = _getThemeId(SignumSettings.settings.syntax_theme)

func _loadItems():
    var themes = ThemeManager.syntax_themes.keys()
    var id = 0
    for i in themes:
        add_item(i, id)
        id += 1

func _on_EThemeButton_item_selected(index):
    ThemeManager.loadSyntaxTheme(get_item_text(index))
    ThemeManager.applySyntaxThemeToAllTabs()

func _getThemeId(theme_name : String) -> int:
    var count = get_item_count()
    for i in range(count):
        if get_item_text(i) == theme_name:
            return i
    return 0
