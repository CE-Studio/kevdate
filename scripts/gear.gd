extends Node2D


#region Variables
var collected:bool = false

@onready var sprite:AnimatedSprite2D = $"AnimatedSprite2D"
@onready var particles:CPUParticles2D = $"CPUParticles2D"
#endregion


func _on_player_enter(body:Node2D) -> void:
	if not collected:
		collected = true
		sprite.visible = false
		particles.emitting = true
