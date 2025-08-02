class_name Ice
extends Platform


func _on_player_enter(body:Node2D) -> void:
	if body is Player:
		body.on_ice = true


func _on_player_exit(body:Node2D) -> void:
	if body is Player:
		body.on_ice = false
