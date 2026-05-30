extends CharacterBody3D

@export var move_speed := 5.0
@export var jump_velocity := 4.5
@export var bullet_scene : PackedScene

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var can_attack := true

func _ready():

	add_to_group("player")

	$HealthComponent.died.connect(_on_died)

func _physics_process(delta):

	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	if Input.is_action_just_pressed("shoot"):
		shoot()

	var input_dir = Input.get_vector(
		"move_left",
		"move_right",
		"move_forward",
		"move_backward"
	)

	var direction = (
		transform.basis *
		Vector3(input_dir.x, 0, input_dir.y)
	).normalized()

	if direction:

		velocity.x = direction.x * move_speed
		velocity.z = direction.z * move_speed

	else:

		velocity.x = move_toward(velocity.x, 0, move_speed)
		velocity.z = move_toward(velocity.z, 0, move_speed)

	if Input.is_action_just_pressed("attack"):
		attack()

	move_and_slide()

func take_damage(amount : int):

	$HealthComponent.take_damage(amount)

func _on_died():

	print("Player died")
	
func attack():

	if not can_attack:
		return

	can_attack = false

	$SwordHitbox.monitoring = true

	await get_tree().create_timer(0.2).timeout

	$SwordHitbox.monitoring = false

	await get_tree().create_timer(0.3).timeout

	can_attack = true

func shoot():

	var bullet = bullet_scene.instantiate()

	get_tree().current_scene.add_child(bullet)

	bullet.global_transform = $WeaponPivot.global_transform
