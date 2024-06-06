extends CharacterBody2D
class_name FireBall1
var direction: float
var spawnPos: Vector2
var spawnRot: float
@export var projectileSpeed = 400;
func _physics_process(delta):
	position.x += direction * projectileSpeed * delta
	move_and_slide()
func _ready():
	global_position = spawnPos
	global_rotation = spawnRot
	
func destroy():
	queue_free()
func _on_fire_ball_1_area_area_entered(area):
	if(area.name == "hitArea"):
		$FireBallHit.play()
		hide()
		if(!$FireBallHit.playing):
			destroy()

