extends Area3D

@export var damage := 25

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):

	if not body.is_in_group("enemy"):
		return

	body.take_damage(damage)

	print("Hit Enemy")
