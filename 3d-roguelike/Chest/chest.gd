extends Node3D

# Called when the node enters the scene tree for the first time.
@onready var animation = $"Sketchfab_Scene/AnimationPlayer"

func _ready() -> void:
	open_chest()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func open_chest():
	animation.play("Take 001")
