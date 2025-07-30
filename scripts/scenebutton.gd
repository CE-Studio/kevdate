class_name SceneButtonOld
extends Button


@export_file("*.tscn") var scn:String


func _pressed() -> void:
	get_tree().change_scene_to_file(scn)
