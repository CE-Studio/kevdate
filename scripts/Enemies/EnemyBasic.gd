extends Enemy


#region Variables
const MOVE_SPEED:float = 300.0
const GRAVITY:float = 60.0

var left:bool = false
#endregion


func _ready() -> void:
	left = randf() < 0.5
	velocity.x = MOVE_SPEED * (-1 if left else 1)
	sfx_death = $"AudioStreamPlayer"
	sfx_death.connect("finished", _on_death_sfx_finished)


func _physics_process(delta: float) -> void:
	if is_dying:
		return
	
	if not is_on_floor():
		velocity.y += GRAVITY
	if is_on_wall():
		left = not left
		velocity.x = MOVE_SPEED * (-1 if left else 1)
	move_and_slide()


func _on_player_entered(body: Node2D) -> void:
	super(body)
