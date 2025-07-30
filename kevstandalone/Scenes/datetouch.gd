extends CanvasLayer


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		show()
	elif event is InputEventKey or event is InputEventJoypadButton or event is InputEventJoypadMotion:
		hide()
