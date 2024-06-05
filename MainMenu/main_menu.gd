extends Control

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://Levels/Tutorial_level/tutorialLevel.tscn")


func _on_exit_button_pressed():
	get_tree().quit()

func _ready():
	ProjectSettings.set_setting("display/window/size/window_width_override", 2560)
	ProjectSettings.set_setting("display/window/size/window_height_override", 1440)
	
func _on_options_button_pressed():
	pass # Replace with function body.
