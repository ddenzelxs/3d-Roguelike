extends CharacterBody3D

@export var move_speed: float = 5.0
@export var attack_damage: int = 10
@export var attack_range: float = 2.0

@onready var player = get_tree().current_scene.get_node("Player")
@onready var health = $"HealthComponent"

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var can_attack: bool = true
var gold: int = 10
var xp: int = 10

func _ready():
	add_to_group("enemy")
	health.died.connect(_on_died)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

	if player:
		look_at(player.global_position, Vector3.UP)
		var direction = player.global_position - global_position
		direction.y = 0
		velocity.x = direction.normalized().x * move_speed
		velocity.z = direction.normalized().z * move_speed
		
	else:
		velocity.x = 0
		velocity.z = 0
	move_and_slide()

func take_damage(amount):
	health.take_damage(amount)

func attack():
	if not can_attack:
		return
	can_attack = false
	if player:
		player.take_damage(attack_damage)
	
	await get_tree().create_timer(1.0).timeout
	can_attack = true
	
func _on_died():
	player.add_gold(gold)
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
