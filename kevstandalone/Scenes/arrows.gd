extends Node3D


const arrow:PackedScene = preload("res://arrow.tscn")


@onready var k_u:MeshInstance3D = $kevarrows/Arrowu
@onready var k_d:MeshInstance3D = $kevarrows/Arrowd
@onready var k_l:MeshInstance3D = $kevarrows/Arrowl
@onready var k_r:MeshInstance3D = $kevarrows/Arrowr
@onready var k_p:Node3D = $kevarrows/pf

@onready var d_u:MeshInstance3D = $otherarrows/Arrowu
@onready var d_d:MeshInstance3D = $otherarrows/Arrowd
@onready var d_l:MeshInstance3D = $otherarrows/Arrowl
@onready var d_r:MeshInstance3D = $otherarrows/Arrowr
@onready var d_p:Node3D = $otherarrows/pf


func addarrow(p:Node3D, a:Node3D) -> void:
	var na:MeshInstance3D = arrow.instantiate()
	p.add_child(na)
	na.rotation = a.rotation
	na.position = a.position + Vector3(0, -12, -0.5)
	


func ku() -> void:
	addarrow(k_p, k_u)

func kd() -> void:
	addarrow(k_p, k_d)

func kl() -> void:
	addarrow(k_p, k_l)

func kr() -> void:
	addarrow(k_p, k_r)

func du() -> void:
	addarrow(d_p, d_u)

func dd() -> void:
	addarrow(d_p, d_d)

func dl() -> void:
	addarrow(d_p, d_l)

func dr() -> void:
	addarrow(d_p, d_r)


func addpoint() -> void:
	$"../CanvasLayer".hp += randf_range(3, 5)


func rempoint() -> void:
	$"../kevin/Player/afk".play()
	$"../CanvasLayer".hp -= randf_range(2, 4)


func procinp(a:Node3D) -> void:
	for i:Node3D in k_p.get_children():
		if i.position.x == a.position.x:
			if abs(i.position.y - a.position.y) < 0.5:
				i.queue_free()
				addpoint()
				return
	rempoint()


func _input(event: InputEvent) -> void:
	if not visible:
		return
	if event.is_action_pressed("Up"):
		$"../kdan".play("RESET")
		$"../kdan".play("u")
		procinp(k_u)
	elif event.is_action_pressed("Down"):
		$"../kdan".play("RESET")
		$"../kdan".play("d")
		procinp(k_d)
	elif event.is_action_pressed("Left"):
		$"../kdan".play("RESET")
		$"../kdan".play("l")
		procinp(k_l)
	elif event.is_action_pressed("Right"):
		$"../kdan".play("RESET")
		$"../kdan".play("r")
		procinp(k_r)


func _process(delta: float) -> void:
	for i:Node3D in k_p.get_children():
		i.position.y += delta * 4.0
		if i.position.y > 1.5:
			i.queue_free()
			rempoint()
	for i:Node3D in d_p.get_children():
		i.position.y += delta * 4.0
		if i.position.y > 1:
			i.queue_free()
