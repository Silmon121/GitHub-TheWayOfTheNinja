extends CharacterBody2D

class_name Player
#References
@onready var animation = $AnimationPlayer #References animation file
@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") #Library for gravity
@export var tutorialDojo: TutorialDojo
@onready var fireBall1 = load("res://Player/animations/Combat/projectiles/FireBall1.tscn")
@onready var dojoScene = get_tree().get_root().get_node("tutorialLevel")

#Movement declaration
#Walk
@export var speed : int = 100
#Run
@export var sprintSpeed: int = 225
#Jump
@onready var jumpLock = false;
@onready var jumpLockSpeed = false;
@export var jumpVelocity: int  = -400
@onready var currentSpeed: float
@onready var direction = "Right";
@onready var lastMoveDirection_combat = 1;

#Combat

#Health declaration
signal healthChanged
@export var maxHealth: int = 100;
@onready var currentHealth: int = maxHealth
@onready var isHurt = false;

#Stamina declaration
signal staminaChanged #Bars will catch this signal
@export var maxStamina: float = 100;
@onready var currentStamina: float = maxStamina;
@export var staminaRecoverRate: float = 0.5;
@export var staminaDepletion: float = 0.5;
@onready var staminaDepleated: bool = false;

#Chakra declaration
signal chakraChanged
@export var maxChakra: float = 80;
@onready var currentChakra: float = maxChakra;
@export var chakraRecoveryRate: float = 0.5;
#Chakra combat
@export var fireball1_cast: float = 20;
@onready var fireBallReady: bool = true;

#Handle movement
func movement(delta, moveDirection):
	#If the game is paused
	if(tutorialDojo.paused == false):
		#This controls if stamina has been depleated
		if (currentStamina == 0):
			staminaDepleated = true
		elif (currentStamina == floor(maxStamina)):
			staminaDepleated = false
		#Run, walk ,idle
		#Locks speed before jumping
		if(jumpLockSpeed == false):
			#Is running
			if (Input.is_action_pressed("sprint") and staminaDepleated == false and moveDirection != 0 and is_on_floor()):
				velocity.x = moveDirection * sprintSpeed
				currentSpeed = sprintSpeed
				if (currentStamina > 0):
					currentStamina -= staminaDepletion
					staminaChanged.emit()
			#Is walking
			elif(is_on_floor() and moveDirection != 0 and !Input.is_action_pressed("sprint")):
				velocity.x = moveDirection * speed
				currentSpeed = speed
				if (currentStamina + staminaRecoverRate < maxStamina):
					currentStamina += staminaRecoverRate
					staminaChanged.emit()
				else:
					currentStamina = maxStamina
			#Is idle
			elif(moveDirection == 0 and is_on_floor() and !Input.is_action_pressed("sprint")):
				velocity.x = 0
				if (currentStamina + staminaRecoverRate*2 < maxStamina):
					currentStamina += staminaRecoverRate *2
					staminaChanged.emit()
				else:
					currentStamina = maxStamina
					staminaChanged.emit()
		#Wants to jump
		if Input.is_action_just_pressed("jump") and is_on_floor() and currentStamina >= 10 and staminaDepleated == false:
			jumpLockSpeed = true
			velocity.y = jumpVelocity
			currentStamina -= 10
			staminaChanged.emit()
		#Is falling
		if not is_on_floor():
			velocity.y += gravity * delta
			velocity.x = currentSpeed * moveDirection
		else:
			jumpLockSpeed = false;
#Handle animations
func updateAnimation(moveDirection):
	if(tutorialDojo.paused == false):
		if moveDirection == 1: 
			direction = "Right"
		elif moveDirection == -1:
			direction = "Left"
		var lastMoveDirection = direction
		if velocity.y < 0:
			animation.play("jump"+ direction)
			jumpLock = true
		elif velocity.y > 0:
			animation.play("fall"+ direction)
			jumpLock = false
		elif is_on_floor() and moveDirection == 0:
			animation.play("idle"+ lastMoveDirection)
		elif (Input.is_action_pressed("left") or Input.is_action_pressed("right")) and is_on_floor() and jumpLock == false and velocity.y >= 0 :
			if (Input.is_action_pressed("sprint") and (direction == "Left" or direction == "Right")) and currentStamina > 0 and staminaDepleated == false:
				animation.play("run"+direction)
			elif direction == "Left" or direction == "Right":
				animation.play("walk"+direction)
func combat(moveDirection):
	#Katana combat
	#Chakra combat
	if(Input.is_action_just_pressed("castSpell1") and currentChakra > 9 and fireBallReady):
		var fireBall1_instance = fireBall1.instantiate()
		fireBall1_instance.direction = lastMoveDirection_combat
		fireBallReady = false
		if (lastMoveDirection_combat == -1):
			fireBall1_instance.spawnRot = -91.2
			fireBall1_instance.spawnPos = global_position - Vector2(30,0)
		else:
			fireBall1_instance.spawnRot = 0
			fireBall1_instance.spawnPos = global_position+ Vector2(30,0)
		dojoScene.add_child.call_deferred(fireBall1_instance)
		currentChakra -= fireball1_cast
		chakraChanged.emit()
#Regenerate chakra
func chakraRegen():
	if(Input.is_action_pressed("regenerateChakra") and currentChakra + chakraRecoveryRate < maxChakra):
		currentChakra += chakraRecoveryRate
		chakraChanged.emit()
	elif(Input.is_action_pressed("regenerateChakra")):
		currentChakra = maxChakra
		chakraChanged.emit()
#Apply physics
func _physics_process(delta):
	#Determines direction in which player wants to move
	var moveDirection = 0
	if (Input.is_action_pressed("left") or Input.is_action_pressed("right")):
		moveDirection = Input.get_axis("left", "right");
	if(moveDirection == 1 or moveDirection == -1):
			lastMoveDirection_combat = moveDirection
	movement(delta, moveDirection)
	updateAnimation(moveDirection)
	move_and_slide()
	combat(moveDirection)
	chakraRegen()
#Registers, when the player will colide with enemy.
func _on_hurt_box_area_entered(area):
	if area.name == "enemyArea":
		currentHealth -= 10
	healthChanged.emit()
func _on_fire_ball_cd_timeout():
	fireBallReady = true;
	$FireBallCD.start()
