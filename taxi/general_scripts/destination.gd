extends Node3D
var flashing = false
var assigned = false

func _process(delta: float) -> void:
	if !assigned:
		$MeshInstance3D.visible = false
	if !flashing and assigned:
		flashing = true
		$MeshInstance3D.visible = false
		await get_tree().create_timer(1).timeout
		$MeshInstance3D.visible = true
