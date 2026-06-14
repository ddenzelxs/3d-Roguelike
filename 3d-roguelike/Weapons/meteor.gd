extends Area3D

var speed = 40.0
var damage = 100

func _ready():
	body_entered.connect(_on_body_entered)
	
	# RANDOM SIZE: Scale between 0.5x (small) and 3.0x (massive)
	var random_size = randf_range(0.5, 5.0)
	scale = Vector3(random_size, random_size, random_size)
	
	# Bigger meteors fall faster!
	speed = speed * random_size 

func _physics_process(delta):
	global_position.y -= speed * delta
	if global_position.y < 0:
		explode()

func _on_body_entered(body):
	if body.is_in_group("enemy"):
		if body.has_method("take_damage"):
			# Bigger meteors do more damage!
			body.take_damage(int(damage * scale.y))
		explode()

func explode():
	# Play explosion sound
	AudioManager.play(AudioManager.meteor_impact)
	
	# Trigger Screen Shake (duration: 0.3s, intensity based on meteor size)
	var shake_power = 0.2 * scale.y
	get_tree().call_group("camera", "shake", 0.3, shake_power)
	
	queue_free()
