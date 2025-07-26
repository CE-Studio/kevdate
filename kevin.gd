class_name Player
extends CharacterBody2D

#region Constants
const SPEED := 1500.0          # Max ground speed
const ACCELERATION := 0.25      # How quickly player accelerates on ground
const FRICTION := 0.2          # How quickly player decelerates on ground

const JUMP_VELOCITY := -2000.0   # Initial upward velocity for jump
const JUMP_GRAVITY_MULTIPLIER := 0.5 # Less gravity during ascending jump (for variable jump height)

const AIR_ACCELERATION := 0.1  # How quickly player accelerates in air
const AIR_FRICTION := 0.1      # How quickly player decelerates in air
const MAX_AIR_SPEED := 1500.0   # Max horizontal speed in air
#endregion

var states: Dictionary[StringName, State]
var state_machine: StateMachine

func _ready() -> void:
	_state_setup()
	state_machine = StateMachine.new(states, "Walk")

func _state_setup() -> void:
	# Initialize states and pass the player instance
	states["Walk"] = Walk.new(self)
	states["Jump"] = Jump.new(self)
	states["Fall"] = Fall.new(self)

func _process(delta: float) -> void:
	state_machine.tick(delta)

func _physics_process(delta: float) -> void:
	state_machine.physics_tick(delta)



class PlayerState extends State:
	var player: Player

	func _init(character: Player) -> void:
		player = character

	func _common_horizontal_movement(delta: float, current_speed: float, acceleration_factor: float, friction_factor: float) -> void:
		var dir = Input.get_axis("Left", "Right")

		if dir == 0:
			#friction
			player.velocity.x = lerp(player.velocity.x, 0.0, friction_factor)
		else:
			#acceleration
			var target_speed = dir * current_speed
			player.velocity.x = lerp(player.velocity.x, target_speed, acceleration_factor)
			
			# Clamp velocity
			if abs(player.velocity.x) > current_speed:
				player.velocity.x = sign(player.velocity.x) * current_speed

	func _apply_gravity(delta: float) -> void:
		player.velocity += player.get_gravity()

	func physics(delta: float) -> void:
		# physics 
		if !player.is_on_floor():
			_apply_gravity(delta)
		player.move_and_slide() # Always move and slide

# Walk State
class Walk extends PlayerState:

	func enter() -> void:
		print("Walk entered")
		pass

	func exit() -> void:
		print("Walk exited")
		pass

	func update(delta: float) -> void:
		if !player.is_on_floor():
			player.state_machine.switch_state("Fall")
		if Input.is_action_just_pressed("Jump"):
			player.state_machine.switch_state("Jump")
		
	func physics(delta: float) -> void:

		_common_horizontal_movement(delta, player.SPEED, player.ACCELERATION, player.FRICTION)
		super(delta)

# Jump State
class Jump extends PlayerState:

	func enter() -> void:
		print("Jump entered")
		# Apply initial jump velocity
		player.velocity.y = player.JUMP_VELOCITY
		pass

	func exit() -> void:
		print("Jump exited")
		pass

	func update(delta: float) -> void:
		if player.velocity.y > 0:
			player.state_machine.switch_state("Fall")

		elif player.is_on_floor():
			player.state_machine.switch_state("Walk")
			

		if Input.is_action_just_released("Jump") and player.velocity.y < 0:
			player.state_machine.switch_state("Fall")


	func physics(delta: float) -> void:
		_common_horizontal_movement(delta, player.MAX_AIR_SPEED, player.AIR_ACCELERATION, player.AIR_FRICTION)

		if player.velocity.y < 0:
			player.velocity += player.get_gravity() * player.JUMP_GRAVITY_MULTIPLIER
		else:
			player.velocity += player.get_gravity()

		player.move_and_slide()

# Fall State
class Fall extends PlayerState:

	func enter() -> void:
		print("Fall entered")
		pass

	func exit() -> void:
		print("Fall exited")
		pass

	func update(delta: float) -> void:
		if player.is_on_floor():
			player.state_machine.switch_state("Walk")
		pass

	func physics(delta: float) -> void:
		_common_horizontal_movement(delta, player.MAX_AIR_SPEED, player.AIR_ACCELERATION, player.AIR_FRICTION)
		super(delta)
