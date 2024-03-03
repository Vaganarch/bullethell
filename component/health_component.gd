class_name HealthComponent
extends Node2D

@export var max_health:int = 5
@export var current_health:int = 5
@export var offset: Vector2

@onready var health_bar: ProgressBar = $HealthBar


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_as_top_level(1)
	health_bar.max_value = max_health

func _process(delta: float) -> void:
	global_position = get_parent().global_position + offset
	health_bar.value = current_health
	if current_health == 0:
		get_parent().queue_free()
	
func take_damage(damage: int) -> void:
	current_health -= damage
