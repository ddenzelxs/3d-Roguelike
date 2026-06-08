extends Node

@onready var spawn_points = $WaveManager/SpawnPoints
@onready var player = get_tree().current_scene.get_node("Player")
var gold := 0

func _process(delta: float) -> void:
	spawn_points.global_position = player.global_position

func add_gold(amount):
	gold += amount
	print("Gold:", gold)
