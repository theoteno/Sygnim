extends OptionButton

var themes = [
    "default",
    "Atom-Dark.thm",
    "Monokai.thm"
    ]

func _ready():
    add_item("Default", 0)
    add_item("Atom Dark", 1)
    add_item("Monokai", 2)
    selected = _getThemeId(SignumSettings.settings.syntax_theme)

func _on_EThemeButton_item_selected(index):
    ThemeManager.loadSyntaxTheme(themes[index])
    ThemeManager.applySyntaxThemeToAllTabs()

func _getThemeId(theme_name : String) -> int:
    var id = 0
    for i in themes:
        if i == theme_name:
            return id
        id += 1
    return 0
