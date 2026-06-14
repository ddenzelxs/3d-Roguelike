extends Node

# These will show up in the Inspector for you to slot sounds into
@export var shoot_sound: AudioStream
@export var enemy_hit_sound: AudioStream
@export var player_hit_sound: AudioStream
@export var jump_sound: AudioStream
@export var level_up_sound: AudioStream
@export var buy_sound: AudioStream
@export var meteor_impact: AudioStream
@export var enuma : AudioStream
@export var vandal : AudioStream

# This function spawns a temporary audio player, plays the sound, and deletes itself
func play(stream: AudioStream, pitch_variance: float = 0.1):
	if stream == null:
		return
		
	var player = AudioStreamPlayer.new()
	player.stream = stream
	
	# Randomize the pitch slightly! This makes repeated sounds (like shooting)
	# sound much less annoying and repetitive.
	if pitch_variance > 0:
		player.pitch_scale = 1.0 + randf_range(-pitch_variance, pitch_variance)
		
	# Delete the player node when the sound finishes so we don't leak memory
	player.finished.connect(player.queue_free)
	
	add_child(player)
	player.play()
