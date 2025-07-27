class_name State
extends RefCounted


var object: Object


func _init(thing: Object) -> void:
	object = thing
	

func enter() -> void:
	pass


func exit() -> void:
	pass


func update(delta: float) -> void:
	pass


func physics(delta: float) -> void:
	pass
