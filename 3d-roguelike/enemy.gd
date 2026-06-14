extends CharacterBody3D

@export var move_speed: float = 5.0
@export var attack_damage: int = 10
@export var attack_range: float = 2.0

@onready var player = get_tree().current_scene.get_node("Player")
@onready var health = $"HealthComponent"
@onready var jump_ray = $JumpRay

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@export var jump_velocity := 9.0
var can_attack: bool = true
var gold: int = 10
var xp: int = 50

func _ready():
	add_to_group("enemy")
	health.died.connect(_on_died)
	jump_ray.add_exception(self)

	add_collision_exception_with(player)
	player.add_collision_exception_with(self)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

	if player and not player.is_dead:
		var direction = player.global_position - global_position
		direction.y = 0

		if direction.length() > 0.1:
			var look_target = player.global_position
			look_target.y = global_position.y

			look_at(look_target, Vector3.UP)

		direction = direction.normalized()

		velocity.x = direction.x * move_speed
		velocity.z = direction.z * move_speed

		if jump_ray.is_colliding():
			var collider = jump_ray.get_collider()

			if collider is GridMap:
				if is_on_floor():
					velocity.y = jump_velocity

	else:
		velocity.x = 0
		velocity.z = 0

	move_and_slide()

func take_damage(amount):
	AudioManager.play(AudioManager.enemy_hit_sound)
	health.take_damage(amount)

func attack():
	if not can_attack:
		return
	if not player or player.is_dead:
		return
	can_attack = false
	if player:
		player.take_damage(attack_damage)
	
	await get_tree().create_timer(1.0).timeout
	can_attack = true
	
func _on_died():
	var final_gold = round(gold * player.gold_multiplier)

	player.add_gold(final_gold)
	player.add_xp(xp)

	queue_free()

func _on_hitbox_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		attack()

func set_damage(value: int):
	attack_damage = value

func set_gold(value: int):
	gold = value
	
func set_xp(value: int):
	xp = value
