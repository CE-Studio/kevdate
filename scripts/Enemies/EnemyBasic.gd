extends Enemy


#region Variables
const MOVE_SPEED:float = 300.0
const GRAVITY:float = 60.0

var left:bool = false
var defeated:bool = false
#endregion


func _ready() -> void:
	left = randf() < 0.5
	velocity.x = MOVE_SPEED * (-1 if left else 1)


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY
	if is_on_wall():
		left = not left
		velocity.x = MOVE_SPEED * (-1 if left else 1)
	move_and_slide()


func _on_player_entered(body: Node2D) -> void:
	if body is Player:
		if abs(body.position.x - position.x) < 64.0 and (body.position.y - position.y) < -128.0:
			if (body.state_machine.current_state == body.states["Jump"]
			or body.state_machine.current_state == body.states["Fall"]):
				defeated = true
				body.velocity.y = body.JUMP_VELOCITY * 0.5
				body.state_machine.switch_state("Jump")
				queue_free()
		else:
			print("shit")
