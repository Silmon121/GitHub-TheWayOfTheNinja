extends Label
@export var player: Player
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.text = str(round(player.currentHealth)) + "/"+ str(player.maxHealth)
