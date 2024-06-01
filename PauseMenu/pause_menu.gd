extends Control

@onready var main = $"../../../../../"

func _ready():
	hide()

func _on_exit_button_pressed():
	get_tree().quit()

func _on_resume_button_pressed():
	main.pauseMenu()
