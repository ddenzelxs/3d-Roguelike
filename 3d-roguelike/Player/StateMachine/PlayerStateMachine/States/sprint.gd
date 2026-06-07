extends Motion

func _enter() -> void:
	print(name)
	$"../../AnimationPlayer".play("Rig_Medium_MovementBasic/Running_A")
	
func _state_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		finished.emit("SprintJump")
 	
	if event.is_action_released("sprint"):
		finished.emit("Run")
	
func _update(delta: float) -> void:
	set_direction()
	calculate_velocity(SPRINT_SPEED, direction, delta)
	
	if direction == Vector3.ZERO:
		finished.emit("Idle")
