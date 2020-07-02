extends Node

#Note : Need to implement settings save / load

#Editor settings
var settings = {
	draw_tabs = true,
	draw_spaces = false,
	highlight_current_line = true,
	caret_block_mode = false,
	show_line_numbers = false
}


#Apply settings to opened tabs
func apply_settings_to_opened_tabs():
	#Get Tab container
	var tab_container = get_node('/root/Main/HSplitContainer/TabContainer')
	
	if tab_container:
		var tabs = tab_container.get_children()
		
		#Apply settings to all tabs
		for i in tabs:
			apply_settings_to_tab(i)


#Apply editor settings to the tab
func apply_settings_to_tab(Tab):
	var text_edit : TextEdit = Tab.get_node("TextEdit")
	text_edit.draw_tabs = settings.draw_tabs
	text_edit.draw_spaces = settings.draw_spaces
	text_edit.highlight_current_line = settings.highlight_current_line
	text_edit.caret_block_mode = settings.caret_block_mode
	text_edit.show_line_numbers = settings.show_line_numbers
