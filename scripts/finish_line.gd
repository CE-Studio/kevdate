extends Node


#region Variables
const SPRITE_MOVE_SPEED:float = 80.0
const SPRITE_MAX_Y:int = 128

@onready var sprite:Sprite2D = $"Sprite2D"
#endregion


func _process(delta: float) -> void:
	sprite.position.y += SPRITE_MOVE_SPEED * delta
	if sprite.position.y >= SPRITE_MAX_Y:
		sprite.position.y -= SPRITE_MAX_Y
