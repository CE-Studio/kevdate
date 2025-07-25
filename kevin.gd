extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0



var states: Dictionary[StringName, state]
var state_machine: StateMachine
func _ready() -> void:
	
	state_machine = StateMachine.new(states, "Walk")
	
	
	
func _state_setup() -> void:
	states.get_or_add("Walk", )	
	#regionend
func _process(delta: float) -> void:
	state_machine.tick(delta)
			
		

func _physics_process(delta: float) -> void:
	state_machine.physics_tick(delta)
	
class Walk extends State:
	func enter() -> void:
		pass
	func exit() -> void:
		pass
	func update(delta: float) -> void:
		pass
	func physics(delta: float) -> void:
		pass
