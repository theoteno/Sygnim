extends Node

#Note : Need to implement settings save / load

#Editor settings
var settings = {
	draw_tabs = true,
	draw_spaces = false,
	highlight_current_line = true,
	caret_block_mode = false
}


#Apply settings to opened tabs
func apply_settings_to_opened_tabs():
	#Get Tab container
	var tab_container = get_node('/root/Main/HSplitContainer/TabContainer')
	
	if tab_container:
		var tabs = tab_container.get_children()
		
		#get Tabs
		for i in tabs:
			var text_edit : TextEdit = i.get_node("TextEdit")
			text_edit.draw_tabs = settings.draw_tabs
			text_edit.draw_spaces = settings.draw_spaces
			text_edit.highlight_current_line = settings.highlight_current_line
			text_edit.caret_block_mode = settings.caret_block_mode


