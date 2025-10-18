extends VehicleBody3D

const MAX_STEER = 0.5
const ENGINE_POWER = 300

func _physics_process(delta: float) -> void:
	var steer_input = Input.get_axis("left", "right")
	var engine_input = Input.get_axis("down", "up")
	
	steering = move_toward(steering, steer_input * MAX_STEER, delta * 2.5)
	engine_force = engine_input * ENGINE_POWER
