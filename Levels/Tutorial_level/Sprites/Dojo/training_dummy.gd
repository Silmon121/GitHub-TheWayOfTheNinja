extends CharacterBody2D

@onready var damageNumberOrigin = $DamageNumberOrigin
func _on_hit_area_area_entered(area):
	if(area.name == "fireBall1Area"):
		DamageNumbers.displayNumber(30,damageNumberOrigin.global_position)
	elif(area.name == "KatanaDamageBox"):
		DamageNumbers.displayNumber(30,damageNumberOrigin.global_position)

