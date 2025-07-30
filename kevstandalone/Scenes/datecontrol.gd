class_name DateControl
extends CanvasLayer


signal  _a
signal  _r(o:String)

const DS:PackedScene = preload("res://death.tscn")

@export var dia:DialogueResource
@onready var lbl:DialogueLabel = $Control/VBoxContainer/PanelContainer/HBoxContainer/DialogueLabel
@onready var chlbl:Label = $Control/VBoxContainer/PanelContainer/HBoxContainer/Label
@onready var bcon:HBoxContainer = $Control/VBoxContainer/HBoxContainer
@onready var nextico:Sprite2D = $Control/VBoxContainer/PanelContainer/Control/Control/Sprite2D
@onready var cam:Camera3D = $"../Camera3D"
@onready var fightbox:PanelContainer = $Control/fightbox
static var kevheart:Sprite2D
static var flags:Array[String] = []
@onready var fightstage = $Control/fightbox/Control/Node2D
@export var bcol:Color
@export var boffcol:Color

@export var center_pos:Marker3D
@export var kev_pos:Marker3D
@export var date_pos:Marker3D
@export var othername:String
@export var attacks:Dictionary[String, PackedScene]

var running := true
var hp:float = 43.81648:
	set(val):
		hp = clampf(val, 0, 43.81648)
		$Control/VBoxContainer/HBoxContainer2/ProgressBar.value = hp
		$Control/VBoxContainer/HBoxContainer2/Label.text = str(hp)
		if hp == 0.0:
			get_tree().change_scene_to_packed.call_deferred(DS)
var fght := false
var canhit := true


@onready var camlpos := cam.global_position
@onready var camlrot := cam.global_rotation


func  _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		_a.emit()


func _ready() -> void:
	Player.gears += 1
	UIHandler.load_scene = load("res://leveldata/datestrike.tres")
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
			$Control/VBoxContainer/PanelContainer.hide()
			$Control/VBoxContainer/HBoxContainer.hide()
			$"../arrows".show()
			$"../AnimationPlayer".play("tesht")
			await $"../AnimationPlayer".animation_finished
			$Control/VBoxContainer/PanelContainer.show()
			$Control/VBoxContainer/HBoxContainer.show()
			$"../arrows".hide()
			show()
			continue
		if "!flags" in  line.text:
			var a = line.text.split("", false)
			a.remove_at(0)
			flags.append_array(a)
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
				if r == "item":
					if Player.gears > 0:
						Player.gears -= 1
						var nhp := randf_range(1, 2)
						hp += nhp
						chlbl.text = "Recoverd " + str(nhp) + " hp!\n You now have " + str(Player.gears) + " gears left"
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


func _on_area_2d_area_entered(area: Area2D) -> void:
	if canhit:
		kevheart.modulate.a = 0.5
		hp -= randf_range(3, 5)
		canhit = false
		$"../Timer".start()
	


func _on_timer_timeout() -> void:
	kevheart.modulate.a = 1
	canhit = true
