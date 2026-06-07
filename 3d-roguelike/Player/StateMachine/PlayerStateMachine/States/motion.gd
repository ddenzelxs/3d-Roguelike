extends State
class_name Motion

signal velocity_updated(vel: Vector3)

const SPEED :float = 5.0
const SPRINT_SPEED :float = 8.0
const JUMP_VELOCITY : float = 10
const GRAVITY: float = -9.8
const ACCELERATION: float = 1000

static var input_dir : Vector2 = Vector2.ZERO
static var direction : Vector3 = Vector3.ZERO
static var velocity : Vector3 = Vector3.ZERO

func _ready() -> void:
	velocity_updated.connect(owner.set_velocity_from_motion)

func set_direction() -> void:
	input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	direction = (owner.global_transform.basis * Vector3(input_dir.x , 0.0, input_dir.y)).normalized()
	
func calculate_velocity(_speed: float, _direction: Vector3, delta: float) -> void:
	velocity.x = move_toward(velocity.x, _direction.x*_speed, ACCELERATION*delta)
	velocity.z = move_toward(velocity.z, _direction.z*_speed, ACCELERATION*delta)
	velocity_updated.emit(velocity)
	
func calculate_gravity(delta: float) -> void:
	if not owner.is_on_floor():
		velocity.y += GRAVITY * delta

func is_on_floor() -> bool:
	return owner.is_on_floor()
