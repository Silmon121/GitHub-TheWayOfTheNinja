extends Control

var paused = false;
func _ready():
	hide()
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		pauseMenu()
func pauseMenu():
	if paused:
		hide()
		Engine.time_scale = 1
	else:
		show()
		Engine.time_scale = 0
	paused = !paused
func _on_exit_button_pressed():
	get_tree().quit()

func _on_resume_button_pressed():
	pauseMenu()
