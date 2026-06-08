extends CharacterBody3D

@export var bullet_scene : PackedScene

@onready var health = $"HealthComponent"
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
	move_and_slide()
	if Input.is_action_just_pressed("shoot"):
		shoot()
		
	if Input.is_action_just_pressed("attack"):
		attack()

func take_damage(amount : int):
	health.take_damage(amount)

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
