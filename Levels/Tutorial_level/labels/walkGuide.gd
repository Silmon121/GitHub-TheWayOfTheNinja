extends Label

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready():
	show()
func _process(delta):
	if(self.visible and !globalChange.changeLabel):
		if(Input.is_action_just_pressed("left") or Input.is_action_just_pressed("right")):
			if(%GuideTimer.time_left == 0):
				%GuideTimer.start()
func _on_guide_timer_timeout():
	if(self.visible):
		hide()
		globalChange.changeLabel = true
		%runGuide.show()
