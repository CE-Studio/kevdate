class_name Player
extends CharacterBody2D

#region Constants
const DS:PackedScene = preload("res://death.tscn")
const physgear:PackedScene = preload("res://physics_gear.tscn")

const SPEED := 1500.0          # Max ground speed
const ACCELERATION := 0.25      # How quickly player accelerates on ground
const FRICTION := 0.2          # How quickly player decelerates on ground

const FRICTION_ICE := 0.002

const JUMP_VELOCITY := -2000.0   # Initial upward velocity for jump
const JUMP_GRAVITY_MULTIPLIER := 0.5 # Less gravity during ascending jump (for variable jump height)

const AIR_ACCELERATION := 0.05  # How quickly player accelerates in air
const AIR_FRICTION := 0.1      # How quickly player decelerates in air
const MAX_AIR_SPEED := 2500.0   # Max horizontal speed in air

const OVERSPEED_FRICTION_MULTIPLIER := 0.05
const OVERSPEED_ACCELERATION_MULTIPLIER := 0.5

const DASH_VELOCITY_X := 2750.0
const DASH_VELOCITY_Y := -1500.0
const DASH_ACCELERATION := 0.01
const DASH_FRICTION := 0.02

const MAX_HEALTH := 4
const INVUL_TIME := 1.25
#endregion

var states: Dictionary[StringName, State]
var state_machine: StateMachine
static var alive := true
static var gears:int = 0
var last_nonzero_vel:Vector2 = Vector2.ZERO
var last_true_vel:Vector2 = Vector2.ZERO
var facing_left:bool = false
var on_ice:bool = false

var health:int = MAX_HEALTH
var invul_time:float = 0.0


@onready var body:Sprite2D = $body
@onready var cam:CamControl = $"Camera2D"
@onready var ui:UIHandler = $"MainUI"

@onready var sfx_jump:AudioStreamPlayer = $"AudioGroup/Jump"
@onready var sfx_dash:AudioStreamPlayer = $"AudioGroup/Dash"
@onready var sfx_damage:AudioStreamPlayer = $"AudioGroup/Damage"

func is_not_moving() -> bool:
	return is_equal_approx(velocity.x / 1000000.0, 0)


func _ready() -> void:
	_state_setup()
	state_machine = StateMachine.new(states, "Walk")

func _state_setup() -> void:
	# Initialize states and pass the player instance
	states["Walk"] = Walk.new(self)
	states["Jump"] = Jump.new(self)
	states["Fall"] = Fall.new(self)
	states["Dash"] = Dash.new(self)

func _process(delta: float) -> void:
	state_machine.tick(delta)
	if invul_time > 0:
		invul_time -= delta
		if invul_time <= 0.0:
			body.visible = true
		else:
			body.visible = not body.visible
	

func _physics_process(delta: float) -> void:
	if velocity.x != 0.0:
		last_nonzero_vel.x = velocity.x
	if velocity.y != 0.0:
		last_nonzero_vel.y = velocity.y
	last_true_vel = velocity
	
	state_machine.physics_tick(delta)
	if not is_not_moving():
		body.flip_h = (velocity.x < 0)


func damage() -> void:
	if invul_time > 0.0:
		return
	if health - 1 <= 0:
		get_tree().change_scene_to_packed.call_deferred(DS)
	else:
		if gears > 0:
			call_deferred("spawn_physgears", gears)
			change_gear_count(-gears)
		else:
			health -= 1
			ui.set_health_meter_noisy(health)
		sfx_damage.play()
	invul_time = INVUL_TIME


func change_gear_count(amount: int) -> void:
	gears += amount
	ui.gear_counter.text = str(gears)


func spawn_physgears(amount: int) -> void:
	for i in range(amount):
		var new_gear = physgear.instantiate()
		new_gear.position = position
		get_parent().add_child(new_gear)
		new_gear.apply_impulse(Vector2(
			randf_range(-2560, 2560),
			randf_range(-2560, 2560)
		))


class PlayerState extends State:
	var player: Player

	func _init(character: Player) -> void:
		player = character

	func _common_horizontal_movement(delta: float, current_speed_cap: float, base_acceleration_factor: float, base_friction_factor: float) -> void:
		var dir = Input.get_axis("Left", "Right")
		var current_abs_speed = abs(player.velocity.x)

		var dynamic_friction_factor = base_friction_factor
		var dynamic_acceleration_factor = base_acceleration_factor

		if current_abs_speed > current_speed_cap:
			var overspeed_amount = current_abs_speed - current_speed_cap
			dynamic_friction_factor += player.OVERSPEED_FRICTION_MULTIPLIER * (overspeed_amount / current_speed_cap)
			dynamic_acceleration_factor *= (1.0 - player.OVERSPEED_ACCELERATION_MULTIPLIER * (overspeed_amount / current_speed_cap))
			dynamic_acceleration_factor = max(0.0, dynamic_acceleration_factor)

		if dir == 0:
			player.velocity.x = lerp(player.velocity.x, 0.0, dynamic_friction_factor)
		else:
			player.facing_left = dir < 0
			var target_speed = dir * current_speed_cap
			player.velocity.x = lerp(player.velocity.x, target_speed, dynamic_acceleration_factor)
			
			if sign(player.velocity.x) != dir and current_abs_speed > current_speed_cap * 0.5:
				player.velocity.x = lerp(player.velocity.x, 0.0, base_friction_factor * 2.0)

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
			player.sfx_jump.play()
		if Input.is_action_just_pressed("Dash"):
			player.state_machine.switch_state("Dash")
		
	func physics(delta: float) -> void:
		var this_friction = player.FRICTION_ICE if player.on_ice else player.FRICTION
		_common_horizontal_movement(delta, player.SPEED, player.ACCELERATION, this_friction)
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
		
		if Input.is_action_just_pressed("Dash"):
			player.state_machine.switch_state("Dash")


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
		if Input.is_action_just_pressed("Dash"):
			player.state_machine.switch_state("Dash")
		pass

	func physics(delta: float) -> void:
		_common_horizontal_movement(delta, player.MAX_AIR_SPEED, player.AIR_ACCELERATION, player.AIR_FRICTION)
		super(delta)

class Dash extends PlayerState:
	
	func enter() -> void:
		print("Dash entered")
		player.velocity = Vector2(
			DASH_VELOCITY_X * (-1 if player.facing_left else 1),
			DASH_VELOCITY_Y
		)
		player.body.rotation_degrees = -90.0 if player.facing_left else 90.0
		player.sfx_dash.play()
		pass
	
	func exit() -> void:
		print("Dash exited")
		player.body.rotation_degrees = 0.0
		pass
	
	func update(delta: float) -> void:
		if player.is_on_floor():
			player.state_machine.switch_state("Walk")
		pass
	
	func physics(delta: float) -> void:
		_common_horizontal_movement(delta, player.DASH_VELOCITY_X, player.DASH_ACCELERATION, player.DASH_FRICTION)
		super(delta)
