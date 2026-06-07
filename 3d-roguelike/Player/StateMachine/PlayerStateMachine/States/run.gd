extends Motion

func _enter() -> void:
	print(name)
	$"../../AnimationPlayer".play("Rig_Medium_MovementBasic/Walking_A")

func _state_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		finished.emit("Jump")
		
	if event.is_action_pressed("sprint") and sprint_remaining > 0.5:
		finished.emit("Sprint")

func _update(delta: float) -> void:
	set_direction()
	calculate_velocity(SPEED, direction, delta)
	replenish_sprint(delta)
	
	if direction == Vector3.ZERO:
		finished.emit("Idle")
	
	if not is_on_floor():
		finished.emit("Fall")
