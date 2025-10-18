extends VehicleBody3D

func _physics_process(delta: float) -> void:
	steering = Input.get_axis("right","left")*0.4
	engine_force = Input.get_axis("down","up") * 100
