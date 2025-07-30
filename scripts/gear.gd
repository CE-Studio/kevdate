extends Node2D


#region Variables
var collected:bool = false

@onready var sprite:AnimatedSprite2D = $"AnimatedSprite2D"
@onready var particles:CPUParticles2D = $"CPUParticles2D"
#endregion


func _on_player_enter(body:Node2D) -> void:
	if not collected and body is Player:
		body.change_gear_count(1)
		collected = true
		sprite.visible = false
		particles.emitting = true


func _on_cpu_particles_2d_finished() -> void:
	queue_free()
