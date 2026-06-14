extends CharacterBody3D

@export var bullet_scene : PackedScene

@onready var health = $"Component/Health"
@onready var gold = $"Component/Gold"
@onready var xp = $"Component/Xp"

var can_attack: bool = true
var spawn: bool = true
var threshold_level: int = 100
var level: int = 1
var damage_multiplier: float = 1.0
var gold_multiplier: float = 1.0
@onready var upgrade_menu = get_tree().current_scene.get_node("UpgradeMenu")
var bullet_speed_multiplier: float = 1.0
var bullet_damage_bonus: int = 0
var move_speed_multiplier: float = 1.0
var attack_cooldown_multiplier: float = 1.0
var is_invincible: bool = false
var is_dead: bool = false
var is_hit: bool = false
var invincibility_duration: float = 0.5
var total_kills: int = 0

func set_velocity_from_motion(vel: Vector3) -> void:
	velocity = vel

func _ready():
	add_to_group("player")
	health.died.connect(_on_died)
	xp.xp_changed.connect(_on_xp_changed)

	if spawn:
		$"AnimationPlayer".play("Rig_Medium_General/Spawn_Air")
		await $"AnimationPlayer".animation_finished
		spawn = false

	add_to_group("player")
	health.died.connect(_on_died)

	xp.xp_changed.connect(_on_xp_changed)

func _physics_process(delta):

	if is_dead:
		return

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

func take_damage(amount: int):
	AudioManager.play(AudioManager.player_hit_sound)
	if is_invincible or is_dead:
		return
	health.take_damage(amount)
	start_invincibility()

func start_invincibility():
	is_invincible = true

	# Flash the character model
	var model = $Rogue
	var tween = create_tween()
	tween.set_loops(5)
	tween.tween_callback(func(): model.visible = false).set_delay(0.05)
	tween.tween_callback(func(): model.visible = true).set_delay(0.05)

	await get_tree().create_timer(invincibility_duration).timeout
	is_invincible = false
	model.visible = true
	
func add_gold(amount: int):
	gold.add_gold(amount)

func add_xp(amount: int):
	xp.add_xp(amount)
	total_kills += 1

func _on_xp_changed(current_xp: int):
	if current_xp >= threshold_level:
		AudioManager.play(AudioManager.level_up_sound)
		level_up()

func _on_died():
	if is_dead:
		return
	is_dead = true
	is_invincible = true  # can't take more damage while dying

	# Disable the state machine
	var state_machine = $StateMachine
	state_machine.set_physics_process(false)
	state_machine.set_process_input(false)
	velocity = Vector3.ZERO

	$"AnimationPlayer".play("Rig_Medium_General/Death_A")
	await $"AnimationPlayer".animation_finished

	# Show death screen
	var death_screen = get_tree().current_scene.get_node("DeathScreen")
	var wave = get_tree().current_scene.get_node("GameManager/WaveManager").current_wave
	death_screen.show_death_screen(wave, level, gold.gold, total_kills)
	
func attack():
	if not can_attack:
		return
	can_attack = false
	$SwordHitbox.monitoring = true
	await get_tree().create_timer(0.2 * attack_cooldown_multiplier).timeout
	$SwordHitbox.monitoring = false
	await get_tree().create_timer(0.3 * attack_cooldown_multiplier).timeout
	can_attack = true

func shoot():
	AudioManager.play(AudioManager.shoot_sound)
	var bullet = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)
	bullet.global_transform = $WeaponPivot.global_transform
	bullet.speed = bullet.speed * bullet_speed_multiplier
	bullet.damage = bullet.damage + bullet_damage_bonus

func add_threshold_level():
	threshold_level = round(threshold_level * 1.5)
	
func level_up():
	level += 1

	print("")
	print("===== LEVEL UP =====")
	print("Current Level: ", level)
	print("====================")

	xp.remove_xp(threshold_level)

	add_threshold_level()

	upgrade_menu.show_menu()
	
func apply_upgrade(upgrade: Dictionary) -> void:
	var method_name = upgrade.apply
	var value = upgrade.value
	if has_method(method_name):
		call(method_name, value)
	else:
		push_warning("Unknown upgrade method: " + method_name)
func upgrade_max_health(value: int) -> void:
	health.max_health += value
	health.current_health = min(health.current_health + value, health.max_health)
	health.health_changed.emit(health.current_health)
	print("UPGRADE: +", value, " MAX HP")
func upgrade_heal_percent(value: float) -> void:
	var heal_amount = int(health.max_health * value)
	health.current_health = min(health.current_health + heal_amount, health.max_health)
	health.health_changed.emit(health.current_health)
	print("UPGRADE: Healed ", heal_amount, " HP")
func upgrade_damage_multiplier(value: float) -> void:
	damage_multiplier += value
	print("UPGRADE: Damage multiplier now ", damage_multiplier)
func upgrade_gold_multiplier(value: float) -> void:
	gold_multiplier += value
	print("UPGRADE: Gold multiplier now ", gold_multiplier)
func upgrade_bullet_speed(value: float) -> void:
	bullet_speed_multiplier += value
	print("UPGRADE: Bullet speed multiplier now ", bullet_speed_multiplier)
func upgrade_bullet_damage(value: int) -> void:
	bullet_damage_bonus += value
	print("UPGRADE: Bullet damage bonus now +", bullet_damage_bonus)
func upgrade_move_speed(value: float) -> void:
	move_speed_multiplier += value
	print("UPGRADE: Move speed multiplier now ", move_speed_multiplier)
func upgrade_sprint_duration(value: float) -> void:
	var stats = preload("res://Player/player_movement_stats.tres")
	stats.sprint_duration += value
	print("UPGRADE: Sprint duration now ", stats.sprint_duration, "s")
func upgrade_attack_speed(value: float) -> void:
	attack_cooldown_multiplier = max(0.2, attack_cooldown_multiplier - value)
	print("UPGRADE: Attack cooldown multiplier now ", attack_cooldown_multiplier)
