extends CharacterBody2D

class_name Player
#References
@onready var animation = $AnimationPlayer #References animation file
@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") #LIBRARY FOR GRAVITY
@export var tutorialDojo: TutorialDojo
@onready var fireBall1 = load("res://Player/animations/Combat/projectiles/FireBall1.tscn")
@onready var dojoScene = get_tree().get_root().get_node("tutorialLevel")

#MOVEMENT
#SPEED
@export var speed : int = 100 #WALK SPEED
@export var sprintSpeed: int = 225 #RUN SPEED
@export var jumpVelocity: int  = -400 #jUMP SPEED
@onready var currentSpeed: int = speed #HOLDS CURRENT PLAYER SPEED WHEN PLAYER JUMPS
#BOOL
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
	if(is_on_floor()):
		if(moveDirection != 0):
			#RUN MOVEMENT
			if (Input.is_action_pressed("sprint") and staminaDepleated == false):
				position.x += moveDirection * sprintSpeed * delta
				currentSpeed = sprintSpeed
			#WALK MOVEMENT
			elif(!Input.is_action_pressed("sprint") || staminaDepleated):
				position.x += moveDirection * speed * delta
				currentSpeed = speed
		#JUMP MOVEMENT
		if Input.is_action_just_pressed("jump") and currentStamina >= 10 and staminaDepleated == false:
			velocity.y = jumpVelocity
	else:
		#APPLY GRAVITY
		velocity.y += gravity * delta
		position.x += currentSpeed * moveDirection *delta
			
#Handle animations
func updateAnimation(moveDirection):
	#DETERMINES THE DIRECTION OF ANIMATION
	if moveDirection == 1: 
		direction = "Right"
	elif moveDirection == -1:
		direction = "Left"
	#IS ON FLOOR ANIMATIONS
	if is_on_floor():
		#IDLE ANIMATION
		if moveDirection == 0:
			animation.play("idle"+ direction)
		#WALK AND RUN ANIMATION
		elif (moveDirection != 0):
			if (Input.is_action_pressed("sprint") and staminaDepleated == false):
				animation.play("run"+direction)
			else:
				animation.play("walk"+direction)
	else :
		#JUMP ANIMATION
		if velocity.y < 0:
			animation.play("jump"+ direction)
		#FALL ANIMATION
		elif velocity.y > 0:
			animation.play("fall"+ direction)
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
	if(tutorialDojo.paused == false):
		movement(delta, moveDirection)
		staminaControl(moveDirection)
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
func staminaControl(moveDirection):
	#STAMINA DEPLETION CONTROL
	if (currentStamina == 0):
		staminaDepleated = true
	elif (currentStamina == maxStamina):
		staminaDepleated = false
	if(is_on_floor()):
		#IDLE STAMINA RECOVERY
		if(moveDirection == 0):
			if (currentStamina + staminaRecoverRate*2 < maxStamina):
				currentStamina += staminaRecoverRate *2
			else:
				currentStamina = maxStamina
		else:
			#WALK STAMINA RECOVERY
			if(moveDirection != 0):
				if(!Input.is_action_pressed("sprint") || staminaDepleated):
					if (currentStamina + staminaRecoverRate < maxStamina):
						currentStamina += staminaRecoverRate
					else:
						currentStamina = maxStamina
				#RUN STAMINA DEPLETION
				else:
					if (currentStamina > 0):
						currentStamina -= staminaDepletion
		if(Input.is_action_just_pressed("jump")and currentStamina >= 10 and staminaDepleated == false):
			currentStamina -= 10
	staminaChanged.emit()
