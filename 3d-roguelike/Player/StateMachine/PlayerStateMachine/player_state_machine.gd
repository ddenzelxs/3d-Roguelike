extends StateMachine

@export var player_movement_stats: MovementStats
@export var character_model: CharacterModel

func _ready() -> void:
	for child: Motion in get_children():
		child.input_directon_changed.connect(character_model.on_input_direction_changed)
	return super._ready()
