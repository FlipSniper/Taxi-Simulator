extends Node3D

@export var customers: Array[PackedScene]
@export var spawns: Array[Node3D]

@onready var rng = RandomNumberGenerator.new()

func _ready() -> void:
	spawn_customer()

func spawn_customer():
	var spawn = spawns[rng.randi_range(0, spawns.size() - 1)]
	var customer_scene = customers[rng.randi_range(0, customers.size() - 1)]
	var customer = customer_scene.instantiate()

	print("Adding customer:", customer)
	add_child(customer)
	print("Children of spawner now:", get_children())
	
	customer.global_position = spawn.global_position
	print("Spawn position:", spawn.global_position)
	print(spawn)
