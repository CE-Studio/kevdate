class_name CamControl
extends Camera2D


#region Variables
const EASE_RATE:float = 6.0

var cam_zoom:float = 0.5
var focus_point:Vector2 = Vector2.ZERO
#endregion


func _process(delta: float) -> void:
	var this_zoom := zoom.x
	this_zoom = lerp(this_zoom, cam_zoom, EASE_RATE * delta)
	zoom = Vector2(this_zoom, this_zoom)
	
	if focus_point == Vector2.ZERO:
		position = position.lerp(Vector2.ZERO, EASE_RATE * delta)
	else:
		global_position = global_position.lerp(focus_point, EASE_RATE * delta)
