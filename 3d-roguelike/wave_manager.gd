extends Node

@export var enemy_scene : PackedScene

signal wave_changed(wave)
signal gold_changed(amount)

var current_wave := 1
var gold := 0

@onready var enemy_container = $"../EnemyContainer"
@onready var spawn_points = $"../SpawnPoints"

func _ready():

	start_wave()

func start_wave():

	wave_changed.emit(current_wave)

	var enemy_count = current_wave * 3

	for i in enemy_count:
		spawn_enemy()

func spawn_enemy():

	var enemy = enemy_scene.instantiate()

	enemy_container.add_child(enemy)

	var points = spawn_points.get_children()

	var spawn = points.pick_random()
	
	var health = enemy.get_node("HealthComponent")

	health.max_health = 100 + (current_wave * 20)
	health.current_health = health.max_health

	enemy.global_position = spawn.global_position

	enemy.tree_exited.connect(_on_enemy_died)

func _on_enemy_died():

	await get_tree().process_frame

	if enemy_container.get_child_count() == 0:

		current_wave += 1

		print("Starting wave ", current_wave)

		start_wave()

func add_gold(amount):

	gold += amount

	gold_changed.emit(gold)
