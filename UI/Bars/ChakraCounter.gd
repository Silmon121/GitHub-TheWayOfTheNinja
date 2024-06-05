extends Label

@export var ui : UI
@onready var player = ui.player 
func _process(delta):
	self.text = str(round(player.currentChakra)) + "/"+ str(player.maxChakra)
