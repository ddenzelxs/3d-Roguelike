extends Node3D

@export var character: CharacterBody3D
@export var edge_spring_arm = SpringArm3D
@export var camera_alignment_speed: float

var camera_rotation: Vector2 = Vector2.ZERO
var mouse_sensitivity: float = 0.005
var max_y_rotation: float = 1.5

var camera_tween: Tween

@onready var default_edge_spring_arm_length: float = edge_spring_arm.spring_length

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent):
	if event.is_action_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if event is InputEventMouseMotion:
		var mouse_event: Vector2 = event.screen_relative * mouse_sensitivity
		camera_look(mouse_event)
		
	if event.is_action_pressed("swap_camera_alignment"):
		swap_camera_aligment()
		
func camera_look(mouse_movement: Vector2) -> void:
	camera_rotation += mouse_movement
	
	transform.basis = Basis()
	character.transform.basis = Basis()
	
	character.rotate_object_local(Vector3(0,1,0), -camera_rotation.x)
	rotate_object_local(Vector3(1,0,0), -camera_rotation.y)
	
	camera_rotation.y = clamp(camera_rotation.y, -max_y_rotation, max_y_rotation)
	pass
		
func swap_camera_aligment() -> void:
	default_edge_spring_arm_length = -default_edge_spring_arm_length
	set_rear_spring_arm_position(default_edge_spring_arm_length, camera_alignment_speed)
	
func set_rear_spring_arm_position(pos: float, speed: float) -> void:
	if camera_tween:
		camera_tween.kill()
		
	camera_tween = get_tree().create_tween()
	camera_tween.tween_property(edge_spring_arm, "spring_length", pos, speed)
