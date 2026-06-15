extends Node

@export var enemy_types : Array[PackedScene]

signal wave_changed(wave)

var current_wave:int = 1

@onready var enemy_container = $EnemyContainer
@onready var spawn_points = $SpawnPoints

var damage: int = 5
var gold: int = 5
var xp: int = 20

func _ready():
	await get_tree().process_frame
	start_wave()

func start_wave():
	wave_changed.emit(current_wave)
	var enemy_count = round(4 * pow(current_wave, 1.15))
	for i in enemy_count:
		spawn_enemy()

func spawn_enemy():
	await get_tree().create_timer(1.0).timeout
	var random_scene = enemy_types.pick_random()
	var enemy = random_scene.instantiate()
	enemy.set_damage(damage * current_wave)
	enemy.set_gold(gold * current_wave)
	enemy.set_xp(xp * current_wave)
	enemy.scale = Vector3(1.5,1.5,1.5)
	
	enemy_container.add_child(enemy)
	var points = []
	
	for child in spawn_points.get_children():
		if child is Marker3D:
			points.append(child)
			
	var spawn = points.pick_random()
	var health = enemy.get_node("HealthComponent")
	health.max_health = 100 + (current_wave * 20)
	health.current_health = health.max_health
	
	var offset = Vector3(randf_range(-2.0, 2.0), 0, randf_range(-2.0, 2.0))
	enemy.global_position = spawn.global_position + offset
	enemy.tree_exited.connect(_on_enemy_died)

func _on_enemy_died():
	if not is_inside_tree(): return
	await get_tree().process_frame
	if not is_inside_tree(): return
	
	if enemy_container.get_child_count() == 0:
		current_wave += 1
		print("Starting wave ", current_wave)
		start_wave()
