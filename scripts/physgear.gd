extends Node


@onready var sprite:Sprite2D = $"Sprite2D"


func _process(delta: float) -> void:
	sprite.modulate.a -= 0.5 * delta
	if sprite.modulate.a <= 0.0:
		queue_free()
