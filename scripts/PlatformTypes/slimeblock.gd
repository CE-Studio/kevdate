@tool
class_name SlimeBlock
extends Platform


#region Variables
@export_range(2, 16) var width:int = 2:
	set(value):
		width = value
		if box_shape:
			box_shape.size.x = BOX_SCALE_MULT * value
			sprite.size.x = SPR_SCALE_MULT * value
			sprite.position.x = SPR_SCALE_MULT * value * -2
@export_range(2, 16) var height:int = 2:
	set(value):
		height = value
		if box_shape:
			box_shape.size.y = BOX_SCALE_MULT * value
			sprite.size.y = SPR_SCALE_MULT * value
			sprite.position.y = SPR_SCALE_MULT * value * -2

const BOX_SCALE_MULT:int = 96
const SPR_SCALE_MULT:int = 24

@onready var box:CollisionShape2D = $"CollisionShape2D"
@onready var sprite:NinePatchRect = $"NinePatchRect"
@onready var box_shape:RectangleShape2D = box.shape
@onready var area:Area2D = $"Area2D"
@onready var area_box:CollisionShape2D = $"Area2D/CollisionShape2D"
#endregion


func _ready() -> void:
	box.shape = RectangleShape2D.new()
	box_shape = box.shape
	box_shape.size = Vector2(width, height) * BOX_SCALE_MULT
	area_box.shape = box_shape
	width = width
	height = height


func _on_area_2d_body_entered(body: Node2D) -> void:
	print("yo")
