extends Node


const MOVE_SPEED:float = 200.0
const LOADER:PackedScene = preload("uid://cqn5d0qqqd173")

var bounds:Vector2 = Vector2(
	ProjectSettings.get_setting("display/window/size/viewport_width"),
	ProjectSettings.get_setting("display/window/size/viewport_height")
) * 0.5
var buffer:Vector2 = Vector2(90, 70)
var direction:Vector2 = Vector2.ZERO

@onready var doofus:Sprite2D = $"doofus"


func _ready() -> void:
	var rand_roll = randf() * TAU
	direction = Vector2(
		sin(rand_roll),
		cos(rand_roll)
	)


func _process(delta: float) -> void:
	doofus.position += direction * MOVE_SPEED * delta
	var these_bounds := bounds - buffer
	if (doofus.position.x < -these_bounds.x and direction.x < 0
	or doofus.position.x > these_bounds.x and direction.x > 0):
		direction.x *= -1
	if (doofus.position.y < -these_bounds.y and direction.y < 0
	or doofus.position.y > these_bounds.y and direction.y > 0):
		direction.y *= -1
	
	if Input.is_anything_pressed():
		Loader.next = load("res://leveldata/lvl1.tres")
		get_tree().change_scene_to_packed(LOADER)
