class_name ProjectileComponent
extends Node

@export var actor: Node2D
@export var speed: float = 100
@export var direction: Vector2 = Vector2(0, -1)

func _ready() -> void:
	actor.velocity = direction * speed
	actor.rotation -= direction.angle_to(Vector2(0, -1))

func _physics_process(delta: float) -> void:
	actor.move_and_slide()
