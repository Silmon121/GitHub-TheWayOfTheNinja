extends TextureProgressBar

@export var ui : UI
@onready var player = ui.player 
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _ready():
	player.healthChanged.connect(update)
	update()
func update():
	value = player.currentHealth * 100 / player.maxHealth
