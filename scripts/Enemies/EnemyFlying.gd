extends Enemy


#region Variables
const IDLE_SPEED:float = 8.0
const IDLE_RADIUS:float = 16.0
const FLY_SPEED:float = 1200.0
const ATTACK_COOLDOWN:float = 0.75

var fly_mode:int = 0
var theta:float = 0
var target_vector:Vector2 = Vector2.ZERO
var target_point:Vector2 = Vector2.ZERO
var attack_cooldown:float = 0.0
var target_body:Node2D = null

@onready var sprite:Sprite2D = $"Sprite2D"
#endregion


func _ready() -> void:
	target_point = position


func _process(delta: float) -> void:
	theta += delta * IDLE_SPEED
	if theta >= TAU:
		theta -= TAU
	if attack_cooldown > 0.0 and fly_mode == 0:
		attack_cooldown -= delta
	
	if attack_cooldown <= 0.0 and target_body:
		fly_mode = 1
		target_point = target_body.position
		target_vector = target_body.position - position
		attack_cooldown = ATTACK_COOLDOWN
	
	match fly_mode:
		0: # Idle
			position = target_point + (Vector2(sin(theta), sin(theta * 2)) * IDLE_RADIUS)
		1: # Fly down
			sprite.flip_v = true
			position = position.move_toward(target_point, FLY_SPEED * delta)
			if position == target_point:
				target_vector.y *= -1.0
				target_point = position + target_vector
				fly_mode = 2
		2: # Fly back up
			sprite.flip_v = false
			position = position.move_toward(target_point, FLY_SPEED * delta)
			if position == target_point:
				fly_mode = 0


func _on_player_detected(body: Node2D) -> void:
	if body is Player:
		target_body = body


func _on_player_no_longer_detected(body: Node2D) -> void:
	if body == target_body:
		target_body = null


func _on_player_entered(body: Node2D) -> void:
	super(body)
