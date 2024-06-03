extends CharacterBody2D

class_name Player
#References
@onready var animation = $AnimationPlayer #References animation file
@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") #LIBRARY FOR GRAVITY
@export var tutorialDojo: TutorialDojo
@onready var fireBall1 = load("res://Player/animations/Combat/projectiles/FireBall/FireBall1.tscn")
@onready var dojoScene = get_tree().get_root().get_node("tutorialLevel") #USED IN CREATING PROJECTILES IN COMBAT

#MOVEMENT
#SPEED
@export var speed : int = 100 #WALK SPEED
@export var sprintSpeed: int = 225 #RUN SPEED
@export var jumpVelocity: int  = -400 #jUMP SPEED
@onready var currentSpeed: int = speed #HOLDS CURRENT PLAYER SPEED WHEN PLAYER JUMPS
#DIRECTION
@onready var moveDirection = 0; #MAIN SOURCE FOR OTHER DIRECTION VARIABLES
@onready var animationDirection = "Right"; #USED IN ANIMATIONS
@onready var lastMoveDirection = 1; #USED IN COMBAT
#PROGRESS BARS
#HEALTH
signal healthChanged
@export var maxHealth: int = 100;
@onready var currentHealth: int = maxHealth
@onready var isHurt = false;
#STAMINA
signal staminaChanged #Bars will catch this signal
@export var maxStamina: float = 100;
@onready var currentStamina: float = maxStamina;
@export var staminaRecoverRate: float = 0.5;
@export var staminaDepletion: float = 0.5;
@onready var staminaDepleated: bool = false;
@onready var staminaRecovery: bool = false;
#CHAKRA
signal chakraChanged
@export var maxChakra: float = 80;
@onready var currentChakra: float = maxChakra;
@export var chakraRecoveryRate: float = 0.5;
@export var fireball1_cast: float = 20;
@onready var fireBallReady: bool = true;
#COMBAT
#UNARMED_COMBAT
#ARMED_COMBAT
#CHAKRA_COMBAT

#OCCURS CONTINUOUSLY THROUGHOUT THE GAME
func _physics_process(delta):
	if(tutorialDojo.paused == false): #IF MENU ISN'T OPENED
		directionControl() #DETERMINES DIRECTION FOR METHODS BELOW !!NEEDS TO BE FIRST TO COMMIT!!
		timerControl()
		movement(delta,func():staminaControl())
		move_and_slide()
		updateAnimation()
		combat()
		chakraControl()
		
#MOVEMENT - ALLOWS PLAYER TO MOVE, BUT DOESN'T CHANGE ANIMATIONS!
func movement(delta,staminaCheck:Callable):
	staminaCheck.call()
	if(is_on_floor()):
		if(moveDirection != 0):
			#RUN MOVEMENT
			if (Input.is_action_pressed("sprint") and staminaDepleated == false):
				position.x += moveDirection * sprintSpeed * delta
				currentSpeed = sprintSpeed
			#WALK MOVEMENT
			elif(!Input.is_action_pressed("sprint") or staminaDepleated):
				position.x += moveDirection * speed * delta
				currentSpeed = speed
		#JUMP MOVEMENT
		if Input.is_action_just_pressed("jump") and currentStamina >= 10 and staminaDepleated == false:
			velocity.y = jumpVelocity
	else:
		#APPLY GRAVITY
		velocity.y += gravity * delta
		position.x += currentSpeed * moveDirection *delta
#ANIMATIONS - ALLOWS TO CHANGE PLAYER ANIMATIONS, BUT DOESN'T MAKE HIM MOVE!
func updateAnimation():
	#IS ON FLOOR ANIMATIONS
	if is_on_floor():
		#IDLE ANIMATION
		if moveDirection == 0:
			animation.play("idle"+ animationDirection)
		#WALK AND RUN ANIMATION
		elif (moveDirection != 0):
			if (Input.is_action_pressed("sprint") and staminaDepleated == false):
				animation.play("run"+animationDirection)
			else:
				animation.play("walk"+animationDirection)
	else :
		#JUMP ANIMATION
		if velocity.y < 0:
			animation.play("jump"+ animationDirection)
		#FALL ANIMATION
		elif velocity.y > 0:
			animation.play("fall"+ animationDirection)
#COMBAT - ALLOWS PLAYER TO ATTACK
func combat():
	#CHAKRA_COMBAT
	if(Input.is_action_just_pressed("castSpell1") and currentChakra > 9 and fireBallReady):
		var fireBall1_instance = fireBall1.instantiate()
		fireBall1_instance.direction = lastMoveDirection
		fireBallReady = false
		if (lastMoveDirection == -1):
			fireBall1_instance.spawnRot = -91.2
			fireBall1_instance.spawnPos = global_position - Vector2(30,0)
		else:
			fireBall1_instance.spawnRot = 0
			fireBall1_instance.spawnPos = global_position+ Vector2(30,0)
		dojoScene.add_child.call_deferred(fireBall1_instance)
		currentChakra -= fireball1_cast
		chakraChanged.emit()
#COLIDE REGISTRATION
#WHEN PLAYER COLIDES WITH AN ENEMY
func _on_hurt_box_area_entered(area):
	if area.name == "enemyArea":
		currentHealth -= 10
	healthChanged.emit()
#CONTROL_FUNCTIONS
#STAMINA_CONTROL
func staminaControl():
	#STAMINA DEPLETION CONTROL
	if (currentStamina == 0):
		staminaDepleated = true
	elif (currentStamina == maxStamina):
		staminaDepleated = false
		staminaRecovery = false
	#WHEN PERFORMING ANY MOVEMENT
	if(is_on_floor()):
		#IDLE STAMINA RECOVERY
		if(staminaRecovery):
			if(moveDirection == 0):
				if (currentStamina + staminaRecoverRate*2 < maxStamina):
					currentStamina += staminaRecoverRate *2
				else:
					currentStamina = maxStamina
			else:
				#WALK STAMINA RECOVERY
				if(moveDirection != 0):
					if(!Input.is_action_pressed("sprint") or staminaDepleated):
						if (currentStamina + staminaRecoverRate < maxStamina):
							currentStamina += staminaRecoverRate
						else:
							currentStamina = maxStamina
		if (currentStamina > 0 and moveDirection != 0 and Input.is_action_pressed("sprint") and staminaDepleated == false):
			currentStamina -= staminaDepletion
		if(Input.is_action_just_pressed("jump")and currentStamina >= 10 and staminaDepleated == false):
			currentStamina -= 10
	staminaChanged.emit()
#DIRECTION_CONTROL
func directionControl():
	moveDirection = 0
	if (Input.is_action_pressed("left") or Input.is_action_pressed("right")):
		moveDirection = Input.get_axis("left", "right");
	if(moveDirection == 1 or moveDirection == -1):
			lastMoveDirection = moveDirection
	#DETERMINES THE DIRECTION OF ANIMATION
	if moveDirection == 1: 
		animationDirection = "Right"
	elif moveDirection == -1:
		animationDirection = "Left"
#CHAKRA_CONTROL
func chakraControl():
	if(Input.is_action_pressed("regenerateChakra") and currentChakra + chakraRecoveryRate < maxChakra):
		currentChakra += chakraRecoveryRate
		chakraChanged.emit()
	elif(Input.is_action_pressed("regenerateChakra")):
		currentChakra = maxChakra
		chakraChanged.emit()
#TIMERS
func timerControl(): #CONTROLS WHEN TO START TIMER
	var inputDirection = animationDirection.to_lower()
	if Input.is_action_just_released(inputDirection) or Input.is_action_just_released("sprint")  and is_on_floor():
		$StaminaRecover.start()
	elif staminaDepleated and Input.is_action_pressed("sprint"):
		$StaminaRecover.start()
#STAMINA STARTS RECOVERING AFTER COOLDOWN
func _on_stamina_recover_timeout():
	staminaRecovery = true;
#CAN FIRE FIREBALL AFTER COOLDOWN
func _on_fire_ball_cd_timeout():
	fireBallReady = true;
	$FireBallCD.start()
