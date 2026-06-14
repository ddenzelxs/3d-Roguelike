extends Node

@onready var spawn_points = $WaveManager/SpawnPoints
@onready var player = get_tree().current_scene.get_node("Player")
var gold := 0

@onready var map_generator = $MapGenerator

func _ready():
	map_generator.generate_layout(10, 10)
	#map_generator.generate_test(10, 10)
	map_generator.generate_map()
	player.global_position = map_generator.get_random_spawn_position()

func _process(delta: float) -> void:
	spawn_points.global_position = player.global_position
	
var is_raining_meteors = false
@onready var meteor_scene = preload("res://Meteor.tscn")

func start_meteor_cutscene():
	if is_raining_meteors: return
	is_raining_meteors = true
	
	# Freeze player
	player.set_physics_process(false) 
	
	# Play the video and wait for it to finish
	var video_player = get_tree().current_scene.get_node("VideoCutscene")
	video_player.play_video()
	await video_player.video_finished
	
	# Unfreeze player
	player.set_physics_process(true)
	
	# Start raining!
	var spawner = Timer.new()
	spawner.wait_time = 0.2
	spawner.autostart = true
	spawner.timeout.connect(spawn_meteor)
	add_child(spawner)

# (Keep your spawn_meteor() function exactly the same as before!)

func spawn_meteor():
	var meteor = meteor_scene.instantiate()
	# Spawn randomly in a 40x40 area around the player, 50 meters in the air
	var random_x = randf_range(-20, 20)
	var random_z = randf_range(-20, 20)
	
	meteor.global_position = Vector3(
		player.global_position.x + random_x, 
		50.0, # High up
		player.global_position.z + random_z
	)
	get_tree().current_scene.add_child(meteor)
