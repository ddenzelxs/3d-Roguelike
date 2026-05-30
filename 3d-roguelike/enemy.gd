extends CharacterBody3D

@export var move_speed := 3.0
@export var attack_damage := 10
@export var attack_range := 2.0

var player : Node3D = null
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var can_attack := true

func _ready():
	$HealthComponent.died.connect(_on_died)

func _physics_process(delta):

	if not is_on_floor():
		velocity.y -= gravity * delta

	if player != null:

		look_at(
			player.global_position,
			Vector3.UP
		)
		
		var direction = player.global_position - global_position
		direction.y = 0

		if direction.length() > attack_range:

			velocity.x = direction.normalized().x * move_speed
			velocity.z = direction.normalized().z * move_speed

		else:

			velocity.x = 0
			velocity.z = 0

			attack()

	else:

		velocity.x = 0
		velocity.z = 0

	move_and_slide()

func take_damage(amount):
	$HealthComponent.take_damage(amount)

func _on_detection_area_body_entered(body):

	print("Detected:", body.name)

	if body.is_in_group("player"):
		player = body
		print("Player assigned!")

func attack():

	if not can_attack:
		return

	can_attack = false

	if player:
		player.take_damage(10)

	await get_tree().create_timer(1.0).timeout

	can_attack = true

func _on_died():

	var wave_manager = get_tree().current_scene.get_node("WaveManager")
	wave_manager.add_gold(10)

	queue_free()
	
