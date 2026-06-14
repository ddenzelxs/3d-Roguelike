extends Motion

func _enter() -> void:
	#print(name)
	$"../../AnimationPlayer".play("Rig_Medium_MovementBasic/Jump_Full_Long")
	jump()
	
func _update(delta: float) -> void:
	# Player cant change direction midair
	set_direction() 
	calculate_gravity(delta)
	calculate_velocity(sprint_speed, direction, PLAYER_MOVEMENT_STATS.in_air_acceleration, delta)
	
	sprint_remaining -= delta
	
	if velocity.y <= 0:
		finished.emit("SprintFall")
	
	input_directon_changed.emit(input_dir)

func jump() -> void:
	velocity.y = jump_gravity
