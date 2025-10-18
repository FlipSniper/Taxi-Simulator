extends Control


func respawn() -> void:
	var taxi = get_tree().current_scene.get_node_or_null("Player")
	taxi.toggle_spawn()
