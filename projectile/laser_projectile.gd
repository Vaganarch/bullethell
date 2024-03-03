extends CharacterBody2D

@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var sprite_2d: Sprite2D = $Sprite2D

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.find_child('HealthComponent'):
		if body.find_child('HealthComponent').has_method('take_damage'):
			body.find_child('HealthComponent').take_damage(1)
			queue_free()
	
