extends VBoxContainer
# Script for the text editor settings

#Set settings
func _ready():
    $DrawTabs/CheckButton.pressed = SignumSettings.settings.draw_tabs
    $DrawSpaces/CheckButton.pressed = SignumSettings.settings.draw_spaces
    $HighlightCurrent/CheckButton.pressed = SignumSettings.settings.highlight_current_line
    $Caret/CheckButton.pressed = SignumSettings.settings.caret_block_mode
    $ShowLineNumbers/CheckButton.pressed = SignumSettings.settings.show_line_numbers


# Draws tabs to make them visible
func draw_tabs_toggled(button_pressed):
    SignumSettings.settings.draw_tabs = button_pressed
    SignumSettings.applySettingsToAllTabs()


# Makes spaces visible
func draw_spaces_toggled(button_pressed):
    SignumSettings.settings.draw_spaces = button_pressed
    SignumSettings.applySettingsToAllTabs()


# Highlights the current line
func highlight_current_line_toggled(button_pressed):
    SignumSettings.settings.highlight_current_line = button_pressed
    SignumSettings.applySettingsToAllTabs()


# Toggles if the caret is block mode (Think of the bash caret)
func caret_toggled(button_pressed):
    SignumSettings.settings.caret_block_mode = button_pressed
    SignumSettings.applySettingsToAllTabs()

# Toggles line numbers
func show_line_numbers_toggled(button_pressed):
    SignumSettings.settings.show_line_numbers = button_pressed
    SignumSettings.applySettingsToAllTabs()
