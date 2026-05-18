extends CharacterBody3D

@export var SPEED = 5.0
@export var mouse_sensitivity = 0.002
@export var shoot_distance = 100.0
@export var time_left: float = 20.0

const JUMP_VELOCITY = 4.5
var score = 0
var rotation_x = 0.0

@onready var score_label = $CanvasLayer/ScoreLabel
@onready var timer_label = $CanvasLayer/TimerLabel

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		rotation_x -= event.relative.y * mouse_sensitivity
		rotation_x = clamp(rotation_x, deg_to_rad(-80), deg_to_rad(80))
		$Pivot/Camera3D.rotation.x = rotation_x
		
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			shoot()

func _process(delta):
	if time_left > 0:
		time_left -= delta
		timer_label.text = "Time: " + str(int(time_left))
	else:
		game_over()
		
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func shoot():
	var from = $Pivot/Camera3D.global_transform.origin
	var to = from + -$Pivot/Camera3D.global_transform.basis.z * shoot_distance

	var space = get_world_3d().direct_space_state
	
	var query = PhysicsRayQueryParameters3D.create(from, to)
	var result = space.intersect_ray(query)

	if result:
		if result.collider.has_method("hit"):
			result.collider.hit()
			add_score()
			
func add_score():
	score += 10
	score_label.text = "Point: " + str(score)
	
func game_over():
	time_left = 0
	timer_label.text = "Time: 0"
	print("GAME OVER")
	
	get_tree().reload_current_scene()
