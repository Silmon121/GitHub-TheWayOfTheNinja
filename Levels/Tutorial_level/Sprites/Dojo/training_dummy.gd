extends CharacterBody2D

@onready var damageNumberOrigin = $DamageNumberOrigin
func _on_hit_area_area_entered(area):
	if(area.name == "fireBall1Area"):
		DamageNumbers.displayNumber(30,damageNumberOrigin.global_position)
	elif(area.name == "KatanaDamageBox"):
		DamageNumbers.displayNumber(20,damageNumberOrigin.global_position)
	elif(area.name == "ShurikenArea"):
		DamageNumbers.displayNumber(10,damageNumberOrigin.global_position)
	elif(area.name == "KunaiArea"):
		DamageNumbers.displayNumber(15,damageNumberOrigin.global_position)
