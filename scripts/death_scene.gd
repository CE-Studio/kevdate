extends Node2D


const SKELETON_WIGGLER_TIME:float = 2.0
const SKELETON_WIGGLER_RADIUS:float = 100.0
const BUTTON_TIME:float = 2.5

var elapsed:float = 0.0
var button_active:bool = false

@onready var kevins_demise:Sprite2D = $"KevinsDemise"
@onready var button:TextureButton = $"CanvasLayer/Control/TextureButton"


func _ready() -> void:
	button.visible = false


func _process(delta: float) -> void:
	elapsed += delta
	if elapsed < SKELETON_WIGGLER_TIME:
		var this_mult:float = inverse_lerp(SKELETON_WIGGLER_TIME, 0.0, elapsed)
		kevins_demise.position = Vector2(
			randf_range(-this_mult, this_mult),
			randf_range(-this_mult, this_mult)
		) * SKELETON_WIGGLER_RADIUS
	
	if elapsed >= BUTTON_TIME and not button_active:
		button_active = true
		button.visible = true
	if button_active:
		button.modulate.a = elapsed - BUTTON_TIME
