extends Label

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(self.visible and !globalChange.changeLabel):
		if(Input.is_action_just_pressed("jump")):
			if(%GuideTimer.time_left == 0):
				%GuideTimer.start()
func _on_guide_timer_timeout():
	if(self.visible and !globalChange.changeLabel):
		hide()
		globalChange.changeLabel = true
		%attackGuide.show()
	else:
		globalChange.changeLabel = false
