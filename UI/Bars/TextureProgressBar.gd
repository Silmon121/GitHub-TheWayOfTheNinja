extends TextureProgressBar

@export var player Player
# Called when the node enters the scene tree for the first time.
func _ready():
	player.healthChanged.connect(update)
	update()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
