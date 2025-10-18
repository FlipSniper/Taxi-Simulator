extends VehicleBody3D

const MAX_STEER = 0.5

func _ready():
	pass

func _process(delta: float) -> void:
	steering = move_toward(steering, Input.get_axis("right","left") * MAX_STEER, delta * 2.5)
