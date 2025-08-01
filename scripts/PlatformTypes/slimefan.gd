class_name SlimeFam
extends Platform


#region Variables
const ACCEL_RATE:float = -200.0
const TOP_SPEED:float = -3000.0

var intersecting_bodies:Array[CharacterBody2D] = []
#endregion


func _physics_process(delta: float) -> void:
	for body in intersecting_bodies:
		if body.velocity.y < TOP_SPEED:
			body.velocity.y += ACCEL_RATE * delta


func _on_body_enter(body: Node2D) -> void:
	if body is CharacterBody2D:
		intersecting_bodies.append(body)


func _on_body_exit(body: Node2D) -> void:
	if intersecting_bodies.has(body):
		intersecting_bodies.remove_at(intersecting_bodies.find(body))
