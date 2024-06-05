extends Node
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
@onready var attack = false 
