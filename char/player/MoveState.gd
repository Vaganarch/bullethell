extends LimboState

@onready var animated_sprite_2d: AnimatedSprite2D = $'../../AnimatedSprite2D'
@onready var player: CharacterBody2D = $'../..'

@export var speed: float = 500.0

func _enter() -> void:
	animated_sprite_2d.play('Move')


func _update(_delta: float) -> void:
	player.look_at(player.get_global_mouse_position())
	animated_sprite_2d.flip_v = player.global_position.x - player.get_global_mouse_position().x > 0
	
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var desired_velocity = input_direction * speed

	player.velocity = desired_velocity

	if input_direction.distance_to(Vector2(0, 0)) == 0:
		get_root().dispatch(EVENT_FINISHED)
		
	player.move_and_slide()
