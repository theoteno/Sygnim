extends Node

# Place where settings are stored
const settings_path = "user://settings.dat"

# Editor settings with default settings
var settings = {
    draw_tabs = true,
    draw_spaces = false,
    highlight_current_line = true,
    caret_block_mode = false,
    show_line_numbers = true,
    
    #Last opened files
    last_opened_files = [],
    theme = "",
    syntax_theme = ""
}

func _ready():
    var settings_dict = Utility.loadDictionary(settings_path)
    # File do not exist, So create new file with default settings
    if not settings_dict:
        print("Running for the first time..... Loading default settings")
        # Create file with default settings
        Utility.saveDictionary(settings_path, settings)
        return
    # Copy settings that we have loaded from file to settings 
    # We can also use settings = settings_dict but its less safe
    Utility.dictionaryCpy(settings, settings_dict)
    ThemeManager.loadSyntaxTheme(settings.syntax_theme)


# Apply settings to tabs
func applySettingsToAllTabs():
    #Get Tab opened tabs
    var tabs = get_tree().get_nodes_in_group("Tabs")
    # Apply settings to all tabs
    for i in tabs:
        applySettingsToTab(i)


# Apply editor settings to the tab
func applySettingsToTab(tab):
    if tab.tab_ready:
        var text_edit : TextEdit = tab.text_edit_box
        text_edit.draw_tabs = settings.draw_tabs
        text_edit.draw_spaces = settings.draw_spaces
        text_edit.highlight_current_line = settings.highlight_current_line
        text_edit.caret_block_mode = settings.caret_block_mode
        text_edit.show_line_numbers = settings.show_line_numbers
    else:
        print("Failed to apply settings to tab, Tab not ready")


# Handle quit, As we need to save settings before we close the program
func _notification(what):
    if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
        _on_exit()
    if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
        _on_exit()
        

func _on_exit():
    print("saving .....")
    # Save list of opended files
    saveSession()
    # Save settings
    Utility.saveDictionary(settings_path, settings)
    # Exit
    get_tree().quit(0)

# This function adds opened files to "settings.last_opened_files"
func saveSession():
    # Clear previous list
    settings.last_opened_files.clear()
    # Get opened tabs
    var tabs = get_tree().get_nodes_in_group("Tabs")
    # Append opened files
    for i in tabs:
        # Exclude Untitled files
        if i.file_path != 'Untitled':
            settings.last_opened_files.append(i.file_path)
