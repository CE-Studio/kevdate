class_name StateMachine

var states: Dictionary[StringName, State]
var current_state: State


func _init(states: Dictionary[StringName, State], initial_state: StringName) -> void:
	self.states = states
	
	current_state = self.states.get(initial_state, State)
	current_state.enter()
	
func tick(delta: float):
	current_state.update(delta)

func physics_tick(delta: float):
	current_state.physics(delta)
	
func switch_state(next_state: StringName):
	current_state.exit()
	##simply just dont fuck upo your speling
	
	current_state = states.get(next_state)
	current_state.enter()
		
