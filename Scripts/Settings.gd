extends VBoxContainer
# Script for the text editor settings

onready var text_editor = get_node('/root/Main/HSplitContainer/TextEdit')

# Draws tabs to make them visible
func draw_tabs_toggled(button_pressed):
	text_editor.draw_tabs = button_pressed

# Makes spaces visible
func draw_spaces_toggled(button_pressed):
	text_editor.draw_spaces = button_pressed

# Highlights the current line
func highlight_current_line_toggled(button_pressed):
	text_editor.highlight_current_line = button_pressed

# Toggles if the caret is block mode (Think of the bash caret)
func caret_toggled(button_pressed):
	text_editor.caret_block_mode = button_pressed
