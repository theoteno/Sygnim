extends Control

# Tab scene resource
var tab_scene = preload("res://Scenes/Tab.tscn")
const UNTITLED = 'Untitled'

# Reference to current working tab
var current_tab = null
var current_file = UNTITLED
var max_recents = 10

onready var save_as_file_dialog = get_node('SaveAsFileDialog')
onready var open_file_dialog = get_node('OpenFileDialog')
onready var about_popup = get_node('AboutPopup')
onready var tab_container = get_node("HSplitContainer/Editor/TabContainer")


func _ready():
    updateWindowTitle()
    restorePreviousSession()
    

func restorePreviousSession():
    if SignumSettings.settings.last_opened_files.size() != 0:
        # Open previously opened files
        for i in SignumSettings.settings.last_opened_files:
            newTab(i)
    else:
        # Create new file
        newTab()

#Update title
func updateWindowTitle():
    OS.set_window_title('Signum - ' + current_file)
    

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
# Github Issues = 2

func file_item_pressed(id):
    match id:
        0:
            # Opens file select dialog
            open_file_dialog.popup()
        1:
            # Opens save file dialog
            save_as_file_dialog.popup()
        2:
            # Closes the program
            get_tree().quit()
        3:
            # Creates file
            newTab()
        4:
            # Saves file without changing the name
            pass
            #save_file()

func help_item_pressed(id):
    match id:
        0:
            # Opens about popup
            about_popup.popup()
        1:
            # Opens the github page in the browser
            OS.shell_open('https://github.com/MintStudios/Signum')
        2:
            # Opens issues in github
            OS.shell_open('https://github.com/MintStudios/Signum/issues')


func newTab(path : String = UNTITLED):
    if path == UNTITLED:
        path = _getAvailableUntitledFileName()
    if isFileOpen(path):
        switchToTab(path)
        return

    var new_tab = tab_scene.instance()
    tab_container.add_child(new_tab)
    tab_container.add_tab(path.get_file())
    new_tab.loadFromFile(path)
    var tab_id =  tab_container.get_child_count() - 1
    tab_container.current_tab = tab_id


func _getAvailableUntitledFileName() -> String:
    var file_name : String = UNTITLED
    var count = 1
    while (isFileOpen(file_name)):
        file_name = file_name + count.to_string()
        count += 1
    return file_name
    

# # Opens an existing file
# func open_file_selected(path):
#     #Do not open file if its already opened in editor.
#     #instead switch to that tab
#     if is_file_open(path):
#         switch_to_tab(path)
#         return
    
#     var file = File.new()
#     #Check existence of file
#     if not file.file_exists(path):
#         print("Failed to open %s" % [path])
#         return
        
#     # Creates and reads the file
#     file.open(path, 1)
#     create_new_tab(path)
#     # Makes the TextEdit text the same as the file's
#     current_tab.get_node("TextEdit").text = file.get_as_text()
#     # Closes to prevent memory leaks
#     file.close()
#     # Changes the title to the file path
#     current_file = path
#     title_update()
#     # Checks if the recents list exceeds 10, if not, continues.
#     if $HSplitContainer/Sidebar/Recents/Recents.get_child_count() < max_recents:
#         # Creates button for recent files
#         var button = Button.new()
#         button.focus_mode = Control.FOCUS_NONE
#         $HSplitContainer/Sidebar/Recents/Recents.add_child(button)
#         button.text = path.get_file()
#         # Signal to go to the recent file
#         button.connect("pressed", self, "go_to_recent", [path])


# # Saves the file as a file type
# func save_as_file_selected(path):
#     # Creates and writes the file
#     var file = File.new()
#     file.open(path, 2)
#     file.store_string(current_tab.get_node("TextEdit").text)
#     # Closes to prevent memory leaks
#     file.close()
#     # Changes the title to the file path
#     current_file = path
#     title_update()
#     # Changes tab title to file name
#     tab_container.set_tab_title(tab_container.current_tab, getFileName(current_file))
    
#     current_tab.file_path = current_file


# func save_file():
#     # Path to file
#     var path = current_tab.file_path
#     # Checks if the file hasn't been created. If it has, then it triggers the 'Save As` Dialog
#     if path == UNTITLED:
#         save_as_file_dialog.popup()
#     # If the file exists, writes the file.
#     else:
#         var file = File.new()
#         file.open(path, 2)
#         file.store_string(current_tab.get_node("TextEdit").text)
#         # Closes to prevent memory leaks
#         file.close()
#         # Changes the title to the file path
#         current_file = path

# Signal for going to the recent file
func go_to_recent(path):
    #Do not open file if its already opened in editor.
    #instead switch to that tab
    if isFileOpen(path):
        switchToTab(path)
        return

    # Creates and reads the file
    var file = File.new()
    file.open(path, 1)
    # Makes the TextEdit text the same as the file's
    current_tab.get_node("TextEdit").text = file.get_as_text()
    # Closes to prevent memory leaks
    file.close()
    # Changes the title to the file path
    current_file = path
    updateWindowTitle()

# Clears the recents list
func clear_recents():
    for rcnt in $HSplitContainer/Sidebar/Recents/Recents.get_children():
        # Deletes itself
        rcnt.queue_free()

# Check if File is open in editor
func isFileOpen(file_path : String) -> bool:
    var tabs = tab_container.get_children()
    for i in tabs:
        if i.file_path == file_path:
            return true
    return false


# Switch to tab with given file path
func switchToTab(file_path : String):
    var tabs = tab_container.get_children()
    var id = 0
    for i in tabs:
        if i.file_path == file_path:
            current_tab = i
            tab_container.current_tab = id
        id += 1


#Tab changed
func _on_TabContainer_tab_changed(tab_id):
    var tabs = tab_container.get_children()
    current_tab = tab_container.get_child(tab_id)
    #Hide all tabs
    for i in tabs:
        i.hide()
    
    #Show current tab
    current_tab.show()


# Handle tab repositioning ( Called when user moves tabs)
func _on_TabContainer_reposition_active_tab_request(idx_to):
    var idx_from = tab_container.current_tab
    var tc = tab_container
    
    #Tab moved left to right
    if idx_to > idx_from:
        #re-arrange children
        for i in range(idx_from + 1, idx_to + 1):
            tc.move_child(tc.get_child(i),i - 1)
    
    #Tab moved right to left
    else:
        #re-arrange children
        for i in range(idx_from - 1, idx_to - 1, -1):
            tc.move_child(tc.get_child(i),i + 1)


# Handle tab close
func _on_TabContainer_tab_close(tab_id): 
    # If Only 1 file is open, create new untitled file
    if tab_container.get_tab_count() == 1:
        newTab()
    
    #If first tab then switch to next tab
    if tab_id == 0:
        _on_TabContainer_tab_changed(tab_id + 1)
    # Switch to previous tab
    else:
        _on_TabContainer_tab_changed(tab_id - 1)
    # Remove tab
    tab_container.get_child(tab_id).queue_free()
    tab_container.remove_tab(tab_id)
