extends Area3D

@export var speed = 30
@export var damage = 15

func _physics_process(delta):

	global_position += -transform.basis.z * speed * delta

func _on_body_entered(body):

	if body.has_method("take_damage"):
		body.take_damage(damage)

	queue_free()
