extends Node3D

@export var destinations: Array[Node3D]

@onready var rng = RandomNumberGenerator.new()

var destination
func choose_destination():
	#destination = destinations[rng.randi_range(0, destinations.size() - 1)]
	destination = destinations[0]
	destination.assigned = true

func remove_destination():
	destination.assigned = false
