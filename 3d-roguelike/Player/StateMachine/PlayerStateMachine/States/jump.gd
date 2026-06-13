extends Motion

func _enter() -> void:
	print(name)
	jump()
	$"../../AnimationPlayer".play("Rig_Medium_MovementBasic/Jump_Full_Long")
	
func _update(delta: float) -> void:
	# Player cant change direction midair
	#set_direction() 
	calculate_gravity(delta)
	calculate_velocity(speed, direction, PLAYER_MOVEMENT_STATS.in_air_acceleration, delta)

	if velocity.y <= 0:
		finished.emit("Fall")
		
	input_directon_changed.emit(input_dir)

func jump() -> void:
	velocity.y = jump_velocity
