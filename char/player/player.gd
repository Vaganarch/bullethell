extends CharacterBody2D

@export var speed = 400
@export var dodge_cooldown: float = 0.4
@export var shoot_cooldown: float = 0.2

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var health_component: HealthComponent = $HealthComponent

@onready var hsm: LimboHSM = $LimboHSM
@onready var stand_state: LimboState = $LimboHSM/Stand
@onready var move_state: LimboState = $LimboHSM/Move
@onready var shoot_state: LimboState = $LimboHSM/Shoot
@onready var dash_state: LimboState = $LimboHSM/Dash

var can_dodge: bool = true
var can_shoot: bool = true
var attack_pressed: bool = false

func _ready() -> void:
	_init_state_machine()

#func _unhandled_input(event: InputEvent)  -> void:
	#if event.is_echo():
		#return
	#if event.is_action_pressed('ui_accept'):
		#attack_pressed = true
		#_process_attack_input()
	#if event.is_action_pressed('dash') and hsm.get_active_state() != dash_state:
		#hsm.dispatch("dash!")
		
func get_input() -> void:
	if Input.is_action_pressed('ui_accept'):
		attack_pressed = true
		_process_attack_input()
	if Input.is_action_pressed('dash') and hsm.get_active_state() != dash_state:
		hsm.dispatch("dash!")
		
func _process(delta: float) -> void:
	get_input()

func _process_attack_input() -> void:
	if not attack_pressed or hsm.get_active_state() == shoot_state:
		return
	hsm.dispatch("attack!")
	await get_tree().create_timer(0.2).timeout
	attack_pressed = false

func _init_state_machine() -> void:
	hsm.add_transition(stand_state, move_state, stand_state.EVENT_FINISHED)
	hsm.add_transition(move_state, stand_state, move_state.EVENT_FINISHED)
	hsm.add_transition(stand_state, shoot_state, "attack!")
	hsm.add_transition(move_state, shoot_state, "attack!")
	hsm.add_transition(shoot_state, move_state, shoot_state.EVENT_FINISHED)
	hsm.add_transition(hsm.ANYSTATE, dash_state, "dash!")
	hsm.add_transition(dash_state, move_state, dash_state.EVENT_FINISHED)
	hsm.add_transition(dash_state, shoot_state, "attack!")

	dash_state.set_guard(_can_dodge)
	shoot_state.set_guard(shoot_state.can_enter)

	# Process attack input buffer when move_state is entered.
	# This way we can buffer the attack button presses and chain the attacks.
	
	move_state.call_on_enter(_process_attack_input)

	hsm.initialize(self)
	hsm.set_active(true)
	hsm.set_guard(_can_dodge)
	hsm.set_agent(self)

func _can_dodge() -> bool:
	if can_dodge:
		can_dodge = false
		get_tree().create_timer(dodge_cooldown).timeout.connect(func(): can_dodge = true)
		return true
	return false
	
