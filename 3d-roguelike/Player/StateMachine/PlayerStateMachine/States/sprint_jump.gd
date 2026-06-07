extends Motion

func _enter() -> void:
	print(name)
	$"../../AnimationPlayer".play("Rig_Medium_MovementBasic/Jump_Full_Long")
	jump()
	
func _update(delta: float) -> void:
	# Player cant change direction midair
	#set_direction() 
	calculate_gravity(delta)
	calculate_velocity(SPRINT_SPEED, direction, delta)

	if velocity.y <= 0:
		finished.emit("SprintFall")

func jump() -> void:
	velocity.y = JUMP_VELOCITY
