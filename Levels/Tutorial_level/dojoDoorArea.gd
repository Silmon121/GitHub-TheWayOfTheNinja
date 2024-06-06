extends Area2D

var insideArea = false
func _on_area_entered(area):
	if(area.name == "hurtBox"):
		insideArea = true
func _on_area_exited(area):
	if(area.name == "hurtBox"):
		insideArea = false
func _process(delta):
	if(insideArea and Input.is_action_just_pressed("interact") and globalChange.changeLevel):
		get_tree().change_scene_to_file("res://Levels/Tutorial_level/tutorialLevelGarden.tscn")
