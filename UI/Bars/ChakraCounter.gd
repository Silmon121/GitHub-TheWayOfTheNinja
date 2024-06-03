extends Label

@export var player: Player
func _process(delta):
	self.text = str(round(player.currentChakra)) + "/"+ str(player.maxChakra)
