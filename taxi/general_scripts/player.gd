extends VehicleBody3D

const MAX_STEER = 0.5
const ENGINE_POWER = 2300
const BRAKE_POWER = 50


@export var spawn : Node3D
@onready var front_left_wheel = $front_left_wheel
@onready var front_right_wheel = $front_right_wheel
@onready var rear_left_wheel = $back_left_wheel
@onready var rear_right_wheel = $back_right_wheel

func _physics_process(delta: float) -> void:
	var steer_input = Input.get_axis("right","left")
	var engine_input = Input.get_axis("down", "up")
	var brake_input = Input.is_action_pressed("brake")
	
	# Apply steering to front wheels
	front_left_wheel.steering = steer_input * MAX_STEER
	front_right_wheel.steering = steer_input * MAX_STEER
	rear_left_wheel.engine_force = engine_input * ENGINE_POWER
	rear_right_wheel.engine_force = engine_input * ENGINE_POWER
	var brake_force = BRAKE_POWER if brake_input else 0
	front_left_wheel.brake = brake_force
	front_right_wheel.brake = brake_force
	rear_left_wheel.brake = brake_force
	rear_right_wheel.brake = brake_force
	if Input.is_action_just_pressed("respawn"):
		linear_velocity = Vector3.ZERO
		angular_velocity = Vector3.ZERO
		
		global_transform.origin = spawn.global_position
		global_transform.basis = spawn.global_transform.basis
		
		sleeping = true
		await get_tree().process_frame
		sleeping = false
