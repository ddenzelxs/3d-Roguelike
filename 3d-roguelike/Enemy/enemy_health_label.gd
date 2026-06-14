extends Label3D

@onready var health = $"../../HealthComponent"

func _ready():

	health.health_changed.connect(_update_health)

	_update_health(health.current_health)

func _update_health(value):

	text = str(value) + " HP"

func _process(_delta):

	var cam = get_viewport().get_camera_3d()

	if cam:
		look_at(cam.global_position)
