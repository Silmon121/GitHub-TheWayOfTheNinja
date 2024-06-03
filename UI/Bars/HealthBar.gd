extends TextureProgressBar

@export var player: Player
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _ready():
	player.healthChanged.connect(update)
	update()
func update():
	value = player.currentHealth * 100 / player.maxHealth
