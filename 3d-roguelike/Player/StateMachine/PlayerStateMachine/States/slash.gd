extends Motion

signal slash_started
signal slash_ended

func _enter() -> void:
	slash_started.emit()
	#print(name)
	# Insert Slash Animation Here

func _update(delta: float) -> void:
	pass
	
