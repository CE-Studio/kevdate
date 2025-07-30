class_name DateControl
extends CanvasLayer


signal  _a
signal  _r(o:String)


@export var dia:DialogueResource
@onready var lbl:DialogueLabel = $Control/VBoxContainer/PanelContainer/HBoxContainer/DialogueLabel
@onready var chlbl:Label = $Control/VBoxContainer/PanelContainer/HBoxContainer/Label
@onready var bcon:HBoxContainer = $Control/VBoxContainer/HBoxContainer
@onready var nextico:Sprite2D = $Control/VBoxContainer/PanelContainer/Control/Control/Sprite2D
@onready var cam:Camera3D = $"../Camera3D"
@onready var fightbox:PanelContainer = $Control/fightbox
static var kevheart:Sprite2D
@onready var fightstage = $Control/fightbox/Control/Node2D
@export var bcol:Color
@export var boffcol:Color

@export var center_pos:Marker3D
@export var kev_pos:Marker3D
@export var date_pos:Marker3D
@export var othername:String
@export var attacks:Dictionary[String, PackedScene]

var running := true
var hp:float = 100
var fght := false


@onready var camlpos := cam.global_position
@onready var camlrot := cam.global_rotation


func  _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		_a.emit()


func _ready() -> void:
	kevheart = $Control/fightbox/Control/Node2D/Sprite2D
	bcon.modulate = boffcol
	var line:DialogueLine
	while running:
		if is_instance_valid(line):
			line = await dia.get_next_dialogue_line(line.next_id)
		else:
			line = await dia.get_next_dialogue_line()
		if not is_instance_valid(line):
			break
		if line.text == "!spec":
			hide()
			$"../arrows".show()
			$"../AnimationPlayer".play("tesht")
			await $"../AnimationPlayer".animation_finished
			$"../arrows".hide()
			show()
			continue
		if "!attk" in line.text:
			kevheart.position = Vector2.ZERO
			var attk:Attack = attacks[line.text].instantiate()
			fightstage.add_child(attk)
			fightbox.show()
			fght = true
			await attk.done
			fght = false
			fightbox.hide()
			continue
		chlbl.text = line.character
		match line.character:
			othername:
				camlpos = date_pos.global_position
				camlrot = date_pos.global_rotation
			"Kevin":
				camlpos = kev_pos.global_position
				camlrot = kev_pos.global_rotation
			_:
				camlpos = center_pos.global_position
				camlrot = center_pos.global_rotation
		lbl.dialogue_line = line
		lbl.type_out()
		await lbl.finished_typing
		if line.responses:
			bcon.modulate = bcol
			var r:String = "item"
			while r == "item":
				r = await _r
				print(r)
			if r == "flirt":
				line.next_id = line.responses[0].next_id
			else:
				line.next_id = line.responses[1].next_id
			bcon.modulate = boffcol
		else:
			nextico.show()
			await _a
			nextico.hide()
	print("done")


func _on_texture_button_pressed() -> void:
	_r.emit("flirt")


func _on_texture_button_2_pressed() -> void:
	_r.emit("item")


func _on_texture_button_3_pressed() -> void:
	_r.emit("idk")


func _process(delta: float) -> void:
	cam.global_position = cam.global_position.move_toward(camlpos, delta * 10.0)
	cam.global_rotation = cam.global_rotation.move_toward(camlrot, delta * 10.0)
	nextico.position = Vector2(
		randf_range(-20, -24),
		randf_range(-20, -24),
	)
	nextico.rotation = randf_range(-0.1, 0.1)
	nextico.skew = randf_range(-0.1, 0.1)
	if fght:
		var movv := Input.get_vector("Left", "Right", "Up", "Down").normalized()
		kevheart.position += movv * delta * 250
		kevheart.position = kevheart.position.clamp(Vector2(-120, -120), Vector2(120, 120))
