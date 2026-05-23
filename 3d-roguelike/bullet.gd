extends Area3D

@export var speed := 30
@export var lifetime := 3

var direction = Vector3.ZERO

func _ready():

	await get_tree().create_timer(lifetime).timeout
	queue_free()


func _physics_process(delta):

	global_position += direction * speed * delta
