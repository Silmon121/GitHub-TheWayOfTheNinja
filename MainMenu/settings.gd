extends Control
# Called when the node enters the scene tree for the first time.
func _ready():
	if(DisplayServer.window_get_mode() == 3):
		%OptionButton.selected = 0
	elif(DisplayServer.window_get_mode() == 0):
		%OptionButton.selected = 1
	else:
		%OptionButton.selected = 1
func _on_option_button_item_selected(index):
	if(index == 0):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
	elif(index == 1):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
func _on_button_pressed():
	get_tree().change_scene_to_file("res://MainMenu/main_menu.tscn")
