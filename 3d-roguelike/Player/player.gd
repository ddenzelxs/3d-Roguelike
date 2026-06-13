extends CharacterBody3D

@export var bullet_scene : PackedScene

@onready var health = $"Component/Health"
@onready var gold = $"Component/Gold"
var can_attack: bool = true
var spawn: bool = true

func set_velocity_from_motion(vel: Vector3) -> void:
	velocity = vel

func _ready():
	if spawn:
		$"AnimationPlayer".play("Rig_Medium_General/Spawn_Air")
		await $"AnimationPlayer".animation_finished
		spawn = false
		
	add_to_group("player")
	health.died.connect(_on_died)

func _physics_process(delta):

# AI Generate (2372020) id = AIG_0012372020
	var cam = $CameraSystem.camera
	if cam:
		var screen_center = get_viewport().size / 2
		var origin = cam.project_ray_origin(screen_center)
		var normal = cam.project_ray_normal(screen_center)
		
		var space_state = get_world_3d().direct_space_state
		if space_state:
			var query = PhysicsRayQueryParameters3D.create(origin, origin + normal * 1000.0)
			query.exclude = [get_rid()]
			var result = space_state.intersect_ray(query)
			if result:
				$AimTarget.global_position = result.position
			else:
				$AimTarget.global_position = origin + normal * 1000.0
			
			# Rotate WeaponPivot to look at the AimTarget
			$WeaponPivot.look_at($AimTarget.global_position, Vector3.UP)
# AI Generate (23272020) id = AIG_0012372020

	move_and_slide()
	if Input.is_action_just_pressed("shoot"):
		shoot()
		
	if Input.is_action_just_pressed("attack"):
		attack()

func take_damage(amount : int):
	health.take_damage(amount)
	
func add_gold(amount: int):
	gold.add_gold(amount)

func _on_died():
	$"AnimationPlayer".play("Rig_Medium_General/Death_A")
	await $"AnimationPlayer".animation_finished
	print("Player died")
	#get_tree().reload_current_scene()
	
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
