class_name SceneButton
extends Button


const LOADER:PackedScene = preload("uid://cqn5d0qqqd173")


@export var scene:LevelData


func _pressed() -> void:
	Loader.next = scene
	get_tree().change_scene_to_packed(LOADER)
