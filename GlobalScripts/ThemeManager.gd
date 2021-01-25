extends Node

# var themes = [
#     "res://Themes/Editor_themes/Atom-Dark.thm",
#     "res://Themes/Editor_themes/Monokai.thm"
#     ]

var themes_dir = "res://Themes/Editor_themes/"

var syntax_theme = {
    custom_colors = {},
    keyword_colors = {},
    color_regions = {}
}

func loadSyntaxTheme(theme_name : String):
    #set as current syntax theme
    # settings.syntax_theme_id = theme_id
    # Default theme i.e same as main theme
    if theme_name == "" || theme_name == "default":
        return
    
    var file = File.new()
    # Open syntax Theme file
    var err = file.open(themes_dir + theme_name, File.READ)
    if err != OK:
        print("Failed to load theme " + theme_name)
        return
    # Clear previous theme
    _clearSyntaxTheme()
    _parseThemeFile(file)
    SignumSettings.settings.syntax_theme = theme_name
    file.close()

func _parseThemeFile(file : File):
    var input_type = ""
    #Parse file till the end
    while( not file.eof_reached()):
        var line = file.get_line()
        # Check input Type
        if line == "[custom_colors]":
            input_type = "cc"
            continue
        elif line == "[keyword_colors]":
            input_type = "kc"
            continue
        elif line == "[color_regions]":
            input_type = "cr"
            continue
        
        # Input type is cc (Read custom colors)
        if input_type == "cc":
            var strings = line.split("=")
            
            if strings.size() == 2:
                var property = "custom_colors/" + strings[0]
                var color = strings[1]
                syntax_theme.custom_colors[property] = color
        # Input type is kc (Read keyword colors)
        elif input_type =="kc":
            var strings = line.split("=")
            
            if strings.size() == 2:
                var keyword = strings[0]
                var color = strings[1]
                syntax_theme.keyword_colors[keyword] = color
        # Input type is cr (Read color regions)
        elif input_type =="cr":
            var strings = line.split("=")
            
            if strings.size() == 2:
                var Strings = strings[0]
                var color = strings[1]
                syntax_theme.color_regions[Strings] = color


func _clearSyntaxTheme():
    syntax_theme.custom_colors.clear()
    syntax_theme.keyword_colors.clear()
    syntax_theme.color_regions.clear()


func applySyntaxToAllTabs():
    var tabs = get_tree().get_nodes_in_group("Tabs")
    for i in tabs:
        applySyntaxToTab(i)

func applySyntaxToTab(tab):
    var text_edit : TextEdit = tab.text_edit_box
    
    # Reset to default theme
    if SignumSettings.settings.syntax_theme == "" || SignumSettings.settings.syntax_theme == "default":
        # Set custom colors to null
        var properties = syntax_theme.custom_colors.keys()
        for i in properties:
            text_edit.set(i, null)
        # Clear custom syntax highlighting
        text_edit.clear_colors()
        return
    
    # Apply custom colors
    var properties = syntax_theme.custom_colors.keys()
    for i in properties:
        text_edit.set(i, Color(syntax_theme.custom_colors[i]))
    
    # Apply custom keyword colors
    var keywords =  syntax_theme.keyword_colors.keys()
    for i in keywords:
        text_edit.add_keyword_color(i, Color(syntax_theme.keyword_colors[i]))
    
    #Add color regions
    var regions = syntax_theme.color_regions.keys()
    for i in regions:
        var strings = i.split(",")
        var color = Color(syntax_theme.color_regions[i])
        text_edit.add_color_region(strings[0], strings[1], color)

func getThemeList() -> Array:
    return []