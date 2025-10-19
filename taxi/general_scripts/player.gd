extends VehicleBody3D

const MAX_STEER = 0.5
const ENGINE_POWER = 2300
const BRAKE_POWER = 50

const MIN_STEADY_SPEED = 12
const MAX_STEADY_SPEED = 35
const SPEED_TOLERANCE_TIME = 5.0
const STEADY_START_DELAY = 5.0

var customer = false
var customer_onboard = false
var customer_type = null
var requirement = null

var steady_timer = 0.0
var steady_warning = false
var steady_active = false
var steady_start_timer = 0.0
var speed_mph = 0.0

@export var spawn : Node3D
@onready var front_left_wheel = $front_left_wheel
@onready var front_right_wheel = $front_right_wheel
@onready var rear_left_wheel = $back_left_wheel
@onready var rear_right_wheel = $back_right_wheel
@onready var destination = get_tree().current_scene.get_node_or_null("Destinations")

func _physics_process(delta: float) -> void:
	var steer_input = Input.get_axis("right", "left")
	var engine_input = Input.get_axis("down", "up")
	var brake_input = Input.is_action_pressed("brake")

	front_left_wheel.steering = steer_input * MAX_STEER
	front_right_wheel.steering = steer_input * MAX_STEER
	rear_left_wheel.engine_force = engine_input * ENGINE_POWER
	rear_right_wheel.engine_force = engine_input * ENGINE_POWER

	var brake_force = BRAKE_POWER if brake_input else 0
	front_left_wheel.brake = brake_force
	front_right_wheel.brake = brake_force
	rear_left_wheel.brake = brake_force
	rear_right_wheel.brake = brake_force

	var speed_mps = linear_velocity.length()
	speed_mph = speed_mps * 2.23694
	print(speed_mph)

	if customer_onboard and requirement == "steady":
		if not steady_active:
			start_steady_timer(delta)
		else:
			check_steady_speed(delta)

	if Input.is_action_just_pressed("respawn"):
		linear_velocity = Vector3.ZERO
		angular_velocity = Vector3.ZERO
		global_transform.origin = spawn.global_position
		global_transform.basis = spawn.global_transform.basis
		sleeping = true
		await get_tree().process_frame
		sleeping = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pick_up"):
		print(!customer_onboard, customer)
	if customer and Input.is_action_just_pressed("pick_up") and !customer_onboard:
		destination.choose_destination()
		print("trying")
		customer_onboard = true
		if customer_type == "soldier":
			requirement = "steady"
			steady_start_timer = 0.0
			steady_active = false
			print("Challenge starts in 5 seconds")

func customer_in(body: Node3D) -> void:
	if body.name == "customer":
		print("hmmm")
		customer = true
		customer_type = body.get_parent().get_parent().type

func customer_out(body: Node3D) -> void:
	if body.name == "customer":
		customer = false

func start_steady_timer(delta: float) -> void:
	steady_start_timer += delta
	if steady_start_timer >= STEADY_START_DELAY:
		steady_active = true
		print("Challenge started! Keep between 30–40 mph.")

func check_steady_speed(delta: float) -> void:
	if speed_mph < MIN_STEADY_SPEED or speed_mph > MAX_STEADY_SPEED:
		if not steady_warning:
			steady_warning = true
			steady_timer = 0.0
			print("Speed out of range! Stay between 30–40 mph within 5 seconds!")
		else:
			steady_timer += delta
			if steady_timer >= SPEED_TOLERANCE_TIME:
				fail_steady_requirement()
	else:
		if steady_warning:
			print("Back to steady speed!")
		steady_warning = false
		steady_timer = 0.0

func fail_steady_requirement() -> void:
	print("Failed steady speed requirement! Customer angry")
	destination.remove_destination()
	steady_warning = false
	requirement = null
	customer_onboard = false
	customer = false
	steady_active = false
	steady_timer = 0.0
