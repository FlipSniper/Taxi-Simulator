extends Control

@onready var speed_label = $default/SpeedOMeter
@onready var player = get_tree().current_scene.get_node_or_null("Player")

var challenge = false
var last_onboard_state = false
var money = 0
var prev_money = -1000
func _ready() -> void:
	$soldier.visible = false

func _process(delta: float) -> void:
	if money != prev_money:
		prev_money = money
		$default/money.text = "Money :$"+str(money)

	speed_label.text = str(round(player.speed_mph)) + " mph"

	if last_onboard_state and !player.customer_onboard:
		show_customer_left_message()

	last_onboard_state = player.customer_onboard

	if !player.customer_onboard:
		$signs/TextureRect.texture = null

	if player.customer_type == "soldier":
		$signs/TextureRect.texture = load("res://textures/Soldier.jpg")
		$soldier.visible = true
		$soldier/timer.visible = true
		$soldier/timer.text = str(round(player.steady_timer))

		if !player.steady_active:
			challenge = false
			$soldier/Label5.visible = true
			$soldier/Label3.visible = false
			$soldier/Label.visible = false
			$soldier/Label2.visible = false
		else:
			print("herreeeeeee")
			$soldier/Label5.visible = false
			if !challenge:
				challenge = true
				$soldier/Label3.visible = true
				await get_tree().create_timer(3).timeout
				$soldier/Label3.visible = false

			if player.speed_mph > 35:
				$soldier/Label.visible = true
				$soldier/Label2.visible = false
			elif player.speed_mph < 12:
				$soldier/Label2.visible = true
				$soldier/Label.visible = false
			else:
				$soldier/Label.visible = false
				$soldier/Label2.visible = false
		if player.customer_dropped:
			money += 50
			player.customer_dropped= false


func show_customer_left_message() -> void:
	print("tried")
	$soldier/Label2.visible = false
	$soldier/Label.visible = false
	$soldier.visible = true
	print($soldier.visible)
	$soldier/Label4.visible = true
	print($soldier/Label4.visible)
	await get_tree().create_timer(3).timeout
	$soldier/Label4.visible = false
	$soldier.visible = false

func dictionary():
	$dictionary.visible = !$dictionary.visible
