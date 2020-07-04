extends VBoxContainer
# Script for the text editor settings

#Set settings
func _ready():
	$DrawTabs/CheckButton.pressed = GlobalData.settings.draw_tabs
	$DrawSpaces/CheckButton.pressed = GlobalData.settings.draw_spaces
	$HighlightCurrent/CheckButton.pressed = GlobalData.settings.highlight_current_line
	$Caret/CheckButton.pressed = GlobalData.settings.caret_block_mode
	$ShowLineNumbers/CheckButton.pressed = GlobalData.settings.show_line_numbers


# Draws tabs to make them visible
func draw_tabs_toggled(button_pressed):
	GlobalData.settings.draw_tabs = button_pressed
	GlobalData.apply_settings_to_opened_tabs()


# Makes spaces visible
func draw_spaces_toggled(button_pressed):
	GlobalData.settings.draw_spaces = button_pressed
	GlobalData.apply_settings_to_opened_tabs()


# Highlights the current line
func highlight_current_line_toggled(button_pressed):
	GlobalData.settings.highlight_current_line = button_pressed
	GlobalData.apply_settings_to_opened_tabs()


# Toggles if the caret is block mode (Think of the bash caret)
func caret_toggled(button_pressed):
	GlobalData.settings.caret_block_mode = button_pressed
	GlobalData.apply_settings_to_opened_tabs()

# Toggles line numbers
func show_line_numbers_toggled(button_pressed):
	GlobalData.settings.show_line_numbers = button_pressed
	GlobalData.apply_settings_to_opened_tabs()

