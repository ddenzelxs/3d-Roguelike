extends Area3D

@export var damage := 25

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):

	if not body.is_in_group("enemy"):
		return

	var player = get_tree().current_scene.get_node("Player")

	var final_damage = round(damage * player.damage_multiplier)

	body.take_damage(final_damage)

	print("Hit Enemy for ", final_damage, " damage")
