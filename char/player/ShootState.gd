extends LimboState

@export var combo_cooldown: float = 0.2
@export var attack_cooldown: float = 0
@export var attack_buffer: float = 0.1

@onready var animated_sprite_2d: AnimatedSprite2D = $'../../AnimatedSprite2D'
@onready var marker_2d: Marker2D = $'../../Marker2D'
@onready var player: CharacterBody2D = $'../..'

var anim_index: int = 0
var _can_enter: bool = true
var last_attack_msec: int = -10000
var combo_pressed: bool = true

## This func is used to prevent entering this state using LimboState.set_guard().
## Entry is denied for a short duration after the third attack in the combo is complete.
func can_enter() -> bool:
	return _can_enter

func _enter() -> void:
	player.look_at(player.get_global_mouse_position())
	
	if (Time.get_ticks_msec() - last_attack_msec) < combo_cooldown * 1000:
		# Perform next attack animation in the 3-part combo, if an attack was recently performed.
		anim_index = (anim_index + 1) % 3
	else:
		anim_index = 0
		
	animated_sprite_2d.play('Shoot')
	print(anim_index)
	
	fire_laser()
	
	await animated_sprite_2d.animation_finished
	if is_active():
		get_root().dispatch(EVENT_FINISHED)
	
func fire_laser():
		const LASER_PROJECTILE = preload('res://projectile/laser_projectile.tscn')
		var laser = LASER_PROJECTILE.instantiate()
		
		laser.global_position = marker_2d.global_position
		laser.find_child('ProjectileComponent').direction = marker_2d.global_position.direction_to(player.get_global_mouse_position())
		
		get_parent().add_child(laser)

func _exit() -> void:
	#hitbox.damage = 1
	last_attack_msec = Time.get_ticks_msec()
	#if anim_index == 2 and _can_enter:
		#_can_enter = false
		#await get_tree().create_timer(attack_cooldown).timeout
		#_can_enter = true
