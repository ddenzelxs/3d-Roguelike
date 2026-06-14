extends Node3D

@export var chest_scene: PackedScene

@onready var interactive = $"Interactive"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if randf() < 0.2:
		spawn_chest()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func spawn_chest():
	var points = []
	for child in interactive.get_children():
		if child is Marker3D:
			points.append(child)

	var chest = chest_scene.instantiate()
	var spawn = points.pick_random()
	var offset = Vector3(randf_range(-2.0, 2.0), 1, randf_range(-2.0, 2.0))
	add_child(chest)
	chest.global_position = spawn.global_position + offset
