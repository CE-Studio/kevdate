class_name Enemy
extends CharacterBody2D


#region Variables
const STOMP_HIT_X:int = 96
const STOMP_HIT_Y:int = -64
#endregion


func _on_player_entered(body: Node2D) -> void:
	if body is Player:
		var damage_player:bool = false
		if abs(body.position.x - position.x) < STOMP_HIT_X and (body.position.y - position.y) < STOMP_HIT_Y:
			if (body.state_machine.current_state == body.states["Jump"]
			or body.state_machine.current_state == body.states["Fall"]):
				body.velocity.y = body.JUMP_VELOCITY * 0.5
				body.state_machine.switch_state("Jump")
				queue_free()
			else:
				damage_player = true
		else:
			damage_player = true
		
		if damage_player:
			body.damage()
