extends Control
@onready var speed_label = $default/SpeedOMeter
@onready var player = get_tree().current_scene.get_node_or_null("Player")
var challenge = false

func _process(delta: float) -> void:
	speed_label.text = str(round(player.speed_mph))+ " mph"
	if !player.customer_onboard:
		$signs/TextureRect.texture = null
	elif player.customer_type == "soldier" and player.customer_onboard:
		$soldier/timer.visible = true
		$signs/TextureRect.texture = load("res://textures/Soldier.jpg")
		$soldier.visible = true
		if !player.steady_active:
			$soldier/Label5.visible = true
			challenge = false
		if player.steady_active and !challenge:
			challenge = true
			$soldier/Label5.visible = false
			$soldier/Label3.visible = true
			await get_tree().create_timer(3).timeout
			$soldier/Label3.visible = false
		if player.speed_mph > 35 and player.steady_active:
			$soldier/Label.visible = true
		elif player.speed_mph < 12 and player.steady_active:
			$soldier/Label2.visible = true
		else:
			$soldier/Label.visible = false
			$soldier/Label2.visible = false
		$soldier/timer.text = str(round(player.steady_timer))
	if player.customer_type != "soldier":
		$soldier.visible = false
