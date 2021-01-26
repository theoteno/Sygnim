extends HBoxContainer

onready var file_menu       = get_node('FileMenu')
onready var help_menu       = get_node('HelpMenu')
onready var edit_menu       = get_node('Settings')
onready var editor          = get_tree().get_nodes_in_group("Editor")[0]

# File Menu IDs:
# Open File = 0
# Save As File = 1
# Save File = 4
# Quit = 2
# New File = 3
# ----------------
# Help Menu IDs:
# About = 0
# Github Page = 1

func _ready():
    # Sets all the shortcuts
    file_menu.get_popup().set_item_shortcut(0, set_shortcut(KEY_O), true)
    file_menu.get_popup().set_item_shortcut(1, set_shortcut(KEY_E), true)
    file_menu.get_popup().set_item_shortcut(4, set_shortcut(KEY_Q), true)
    file_menu.get_popup().set_item_shortcut(2, set_shortcut(KEY_S), true)
    file_menu.get_popup().set_item_shortcut(3, set_shortcut(KEY_N), true)
    
    # Connects the signals of the items to the main script
    file_menu.get_popup().connect('id_pressed', self, 'file_item_pressed')
    help_menu.get_popup().connect('id_pressed', self, 'help_item_pressed')


# Function that makes a shortcut
func set_shortcut(key):
    # Creates ShortCut and InputKeyEvent
    var shortcut = ShortCut.new()
    var inputeventkey = InputEventKey.new()
    # Sets the scanned key and uses control as the preceding command
    inputeventkey.set_scancode(key)
    inputeventkey.control = true
    # Makes the final shortcut and returns it
    shortcut.set_shortcut(inputeventkey)
    return shortcut


func file_item_pressed(id):
    match id:
        0:
            # Opens file select dialog
            editor.open_file_dialog.popup()
        1:
            # Opens save file dialog
            editor.save_as_file_dialog.popup()
        2:
            # Closes the program
            get_tree().quit()
        3:
            # Creates file
            editor.newTab()
        4:
            # Saves file without changing the name
            editor.current_tab.saveFile()

func help_item_pressed(id):
    match id:
        0:
            # Opens about popup
            editor.about_popup.popup()
        1:
            # Opens the github page in the browser
            OS.shell_open('https://github.com/MintStudios/Signum')
        2:
            # Opens issues in github
            OS.shell_open('https://github.com/MintStudios/Signum/issues')
