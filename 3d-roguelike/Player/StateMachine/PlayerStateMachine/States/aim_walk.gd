extends Motion

signal aim_entered
signal aim_exited

func _enter() -> void:
	aim_entered.emit()
	print(name)
	# Add Aim Animation Here

func _state_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		finished.emit("Jump")
		
	if event.is_action_pressed("sprint") and sprint_remaining > 0.5:
		aim_exited.emit()
		finished.emit("Sprint")
	
	if event.is_action_released("aim"):
		aim_exited.emit()
		finished.emit("Run")

func _update(delta: float) -> void:
	set_direction()
	calculate_velocity(AIM_SPEED, direction, delta)
	replenish_sprint(delta)
	
	if direction == Vector3.ZERO:
		finished.emit("AimIdle")
	
	if not is_on_floor():
		aim_exited.emit()
		finished.emit("Fall")
