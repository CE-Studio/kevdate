extends Node


const LOADER:PackedScene = preload("uid://cqn5d0qqqd173")
@export_file("*.tres") var load_scene:String = ""
@export var play_win_jingle:bool = false
var hit_once:bool = false
@onready var jingle:AudioStreamPlayer = $"AudioStreamPlayer"


func _on_player_enter(body:Node2D) -> void:
	if hit_once:
		return
	hit_once = true
	if play_win_jingle:
		jingle.play()
	else:
		_load_next()


func _on_jingle_finished() -> void:
	_load_next()


func _load_next() -> void:
	Loader.next = load(load_scene)
	get_tree().change_scene_to_packed(LOADER)
