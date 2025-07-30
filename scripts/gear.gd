extends Node2D


#region Variables
var collected:bool = false

@onready var sprite:AnimatedSprite2D = $"AnimatedSprite2D"
@onready var particles:CPUParticles2D = $"CPUParticles2D"
@onready var sfx:AudioStreamPlayer = $"AudioStreamPlayer"
#endregion


func _on_player_enter(body:Node2D) -> void:
	if not collected and body is Player:
		body.change_gear_count(1)
		collected = true
		sprite.visible = false
		particles.emitting = true
		sfx.pitch_scale = randf_range(0.75, 1.25)
		sfx.play()


func _on_cpu_particles_2d_finished() -> void:
	queue_free()
