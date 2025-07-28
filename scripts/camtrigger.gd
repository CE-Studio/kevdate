extends Area2D


#region Variables
@export var set_zoom:bool = false
@export_range(0.0625, 2.0, 0.0625) var zoom:float = 0.5
@export var set_focus:bool = false
@export var focus_point:Vector2 = Vector2.ZERO
#endregion


func _on_player_entered(body:Node2D) -> void:
	if body is Player:
		if set_zoom:
			body.cam.cam_zoom = zoom
		if set_focus:
			body.cam.focus_point = focus_point
