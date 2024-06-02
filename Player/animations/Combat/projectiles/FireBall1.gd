extends CharacterBody2D

var direction: float
var spawnPos: Vector2
var spawnRot: float
@export var projectileSpeed = 400;
func _physics_process(delta):
	velocity.x = direction * projectileSpeed * delta
	move_and_slide()
func _ready():
	global_position = spawnPos
	global_rotation = spawnRot
	
func destroy():
	queue_free()
func _on_visible_on_screen_notifier_2d_screen_exited():
	destroy()
func _on_fire_ball_1_area_area_entered(area):
	if(area.name == "hitArea"):
		destroy()
	elif(area.name == "TileMap"):
		destroy()
