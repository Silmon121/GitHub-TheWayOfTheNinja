extends Label

func _process(delta):
	if(self.visible):
		globalChange.changeLevel = true
