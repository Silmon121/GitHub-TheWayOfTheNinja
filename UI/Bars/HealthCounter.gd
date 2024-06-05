extends Label
@export var ui : UI
@onready var player = ui.player 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.text = str(round(player.currentHealth)) + "/"+ str(player.maxHealth)
