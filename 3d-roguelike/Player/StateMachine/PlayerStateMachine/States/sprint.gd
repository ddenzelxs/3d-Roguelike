extends Motion

signal sprint_started
signal sprint_ended

func _enter() -> void:
	sprint_started.emit()
	print(name)
	$"../../AnimationPlayer".play("Rig_Medium_MovementBasic/Running_A")
	
func _state_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		finished.emit("SprintJump")
 	
	if event.is_action_released("sprint"):
		sprint_ended.emit()
		finished.emit("Run")
	
func _update(delta: float) -> void:
	set_direction()
	calculate_velocity(sprint_speed, direction, PLAYER_MOVEMENT_STATS.acceleration, delta)

	sprint_remaining -= delta
	get_tree().create_timer(PLAYER_MOVEMENT_STATS.sprint_duration)
	
	if sprint_remaining <= 0.0:
		sprint_ended.emit()
		finished.emit("Run")
	
	if direction == Vector3.ZERO:
		sprint_ended.emit()
		finished.emit("Idle")
	
	input_directon_changed.emit(input_dir)
