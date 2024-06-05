extends Node2D
class_name TutorialDojoGarden
@onready var pause_menu = $TileMap/Player/Camera2D3/CanvasLayer/pauseMenu
#Declaration
var paused = false

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		pauseMenu()
func pauseMenu():
	if paused:
		pause_menu.hide()
		Engine.time_scale = 1
	else:
		pause_menu.show()
		Engine.time_scale = 0
	paused = !paused
