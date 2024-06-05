extends TextureProgressBar

@export var ui : UI
@onready var player = ui.player 
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _ready():
	player.chakraChanged.connect(update)
	update()
func update():
	value = player.currentChakra * 50 / player.maxChakra
