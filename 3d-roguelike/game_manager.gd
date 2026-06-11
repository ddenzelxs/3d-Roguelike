extends Node

@onready var spawn_points = $WaveManager/SpawnPoints
@onready var player = get_tree().current_scene.get_node("Player")
var gold := 0

@onready var map_generator = $MapGenerator

func _ready():
	map_generator.generate_layout(10, 10)
	map_generator.generate_map()
	player.global_position = map_generator.get_random_spawn_position()

func _process(delta: float) -> void:
	spawn_points.global_position = player.global_position
