extends Node


const DEATH_SCENE:PackedScene = preload("res://death.tscn")


func _on_player_enter(body: Node2D) -> void:
	if body is Player:
		get_tree().change_scene_to_packed(DEATH_SCENE)
