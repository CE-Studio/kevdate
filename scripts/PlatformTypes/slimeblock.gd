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
#endregion


func _ready() -> void:
	box.shape = RectangleShape2D.new()
	box_shape = box.shape
	box_shape.size = Vector2(width, height) * BOX_SCALE_MULT
	width = width
	height = height


func _on_body_entered(body: Node) -> void:
	print(body)
	if body is Player:
		print(body.velocity)
		if body.state_machine.current_state == body.states["Fall"]:
			body.velocity.y *= -1.25
			body.state_machine.switch_state("Jump")
