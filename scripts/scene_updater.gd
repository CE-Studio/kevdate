extends Node


@export var scene:String = ""


func _ready() -> void:
	if scene != "":
		UIHandler.load_scene = scene
