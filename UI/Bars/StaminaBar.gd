extends TextureProgressBar

@export var ui : UI
@onready var player = ui.player 
# Called when the node enters the scene tree for the first time.
func _ready():
	player.staminaChanged.connect(updateStamina)
	updateStamina()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func updateStamina():
	value = player.currentStamina * 100 / player.maxStamina
