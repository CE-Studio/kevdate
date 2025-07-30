class_name Enemy
extends CharacterBody2D


#region Variables
const STOMP_HIT_X:int = 96
const STOMP_HIT_Y:int = -64

var is_dying:bool = false

var sfx_death:AudioStreamPlayer = null
#endregion


func _process(delta: float) -> void:
	if is_dying:
		position += Vector2(
			randf_range(-32, 32),
			randf_range(-32, 32)
		)
		scale = Vector2(
			randf_range(0.125, 2),
			randf_range(0.125, 2)
		)


func _on_player_entered(body: Node2D) -> void:
	if is_dying:
		return
	
	if body is Player:
		var damage_player:bool = false
		if abs(body.position.x - position.x) < STOMP_HIT_X and (body.position.y - position.y) < STOMP_HIT_Y:
			if (body.state_machine.current_state == body.states["Jump"]
			or body.state_machine.current_state == body.states["Fall"]
			or body.state_machine.current_state == body.states["Dash"]):
				body.velocity.y = body.JUMP_VELOCITY * 0.5
				body.state_machine.switch_state("Jump")
				if sfx_death:
					sfx_death.play()
					is_dying = true
				else:
					queue_free()
			else:
				damage_player = true
		else:
			damage_player = true
		
		if damage_player:
			body.damage()


func _on_death_sfx_finished() -> void:
	queue_free()
