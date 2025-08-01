class_name SlimeFam
extends Platform


#region Variables
const ACCEL_RATE:float = 12000.0
const TOP_SPEED:float = 3000.0

var intersecting_bodies:Array[CharacterBody2D] = []
var blow_vector:Vector2 = Vector2.UP
#endregion


func _ready() -> void:
	blow_vector = Vector2(
		sin(rotation),
		-cos(rotation)
	)


func _physics_process(delta: float) -> void:
	for body in intersecting_bodies:
		if abs(body.velocity.x) < TOP_SPEED or abs(body.velocity.y) < TOP_SPEED:
			body.velocity += blow_vector * ACCEL_RATE * delta
		if body is Player:
			if body.state_machine.current_state == body.states["Walk"]:
				body.state_machine.switch_state("Fall")


func _on_body_enter(body: Node2D) -> void:
	if body is CharacterBody2D:
		intersecting_bodies.append(body)


func _on_body_exit(body: Node2D) -> void:
	if intersecting_bodies.has(body):
		intersecting_bodies.remove_at(intersecting_bodies.find(body))
