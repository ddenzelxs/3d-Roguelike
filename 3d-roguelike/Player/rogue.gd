extends Node3D
class_name CharacterModel

@export var rig : Node3D
@export var turn_rate: float = 0.1

var current_mouse_rotation: Vector2
var input_dir: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_camera_system_mouse_rotated(_rotation: Vector2) -> void:
	#current_mouse_rotation = _rotation
	#
	#transform.basis = Basis()
	#rotate_object_local(Vector3(0,1,0), current_mouse_rotation.x)
	pass
	
func on_input_direction_changed(_input_direction: Vector2) -> void:
	input_dir = input_dir.lerp(_input_direction, turn_rate)
	rotate_rig(input_dir, current_mouse_rotation.x)

func rotate_rig(angle: Vector2, _offset: float = 0) -> void:
	#var new_angle: float = atan2(angle.x, angle.y) - _offset
	#
	#rig.basis = Basis()
	#rig.rotate_object_local(Vector3(0,1,0), new_angle)
	pass
