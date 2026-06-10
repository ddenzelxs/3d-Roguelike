extends Node3D

@export var chunks: Array[PackedScene]
@export var bound: PackedScene

var chunk_size: Vector3

var layout = []

func _ready() -> void:
	randomize()
	chunk_size = get_chunk_size(chunks[0])
	generate_layout(10, 10)
	print(layout)
	generate_map()
	
func get_chunk_size(chunk: PackedScene) -> Vector3:
	var chunk_instance = chunk.instantiate()

	var chunk_bounds = chunk_instance.get_node_or_null("ChunkSize")
	chunk_bounds = chunk_bounds.get_child(0)

	if chunk_bounds == null:
		return Vector3.ZERO

	var size = chunk_bounds.size
	chunk_instance.free()
	return size

func generate_map():
	for z in range(layout.size()):
		for x in range(layout[z].size()):
			var chunk_id = layout[z][x]
			var chunk_scene: PackedScene
			# corner
			if chunk_id == 99:
				chunk_scene = bound
			else:
				chunk_scene = chunks[chunk_id]
			var chunk_instance = chunk_scene.instantiate()
			chunk_instance.position = Vector3(x * chunk_size.x, 0, z * chunk_size.z)
			add_child(chunk_instance)

func generate_layout(width: int, height: int):
	layout.clear()
	for z in range(height):
		var row = []
		for x in range(width):
			var is_border = (x == 0 or x == width - 1 or z == 0 or z == height - 1)
			if is_border:
				row.append(99)
			else:
				var random_chunk_id = randi_range(0, chunks.size() - 1)
				row.append(random_chunk_id)
		layout.append(row)

func get_random_spawn_position() -> Vector3:
	var valid_positions = []
	for z in range(layout.size()):
		for x in range(layout[z].size()):
			if layout[z][x] != 99:
				valid_positions.append(Vector2i(x, z))
	if valid_positions.is_empty():
		return Vector3.ZERO
	var random_grid_pos = valid_positions.pick_random()
	return Vector3(
		random_grid_pos.x * chunk_size.x,
		5,
		random_grid_pos.y * chunk_size.z
	)
