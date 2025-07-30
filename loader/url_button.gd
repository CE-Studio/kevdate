class_name URIButton
extends Button


@export var uri:String = ""


func _pressed() -> void:
	OS.shell_open(uri)
