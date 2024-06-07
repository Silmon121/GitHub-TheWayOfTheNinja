extends Control

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://Levels/Tutorial_level/tutorialLevel.tscn")


func _on_exit_button_pressed():
	get_tree().quit()

func _ready():
	pass
	
func _on_options_button_pressed():
	get_tree().change_scene_to_file("res://MainMenu/settings.tscn")
