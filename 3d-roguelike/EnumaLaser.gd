extends Area3D

var damage = 1000 # Absolute obliteration
var active_time = 3.0

func _ready():
	# Start flat and expand outward for impact
	scale = Vector3(0.1, 0.1, 1.0)
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector3(1.0, 1.0, 1.0), 0.3).set_trans(Tween.TRANS_ELASTIC)
	
	# Damage everything inside it every 0.1 seconds
	var timer = Timer.new()
	timer.wait_time = 0.1
	timer.autostart = true
	timer.timeout.connect(_deal_damage)
	add_child(timer)
	
	# Fade out and destroy
	get_tree().create_timer(active_time).timeout.connect(fade_out)

func _on_body_entered(body):
	_deal_damage(body)
		

func _deal_damage(body):
	#for body in get_overlapping_bodies():
	if body.is_in_group("enemy") and body.has_method("take_damage"):
		body.take_damage(damage)

func fade_out():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector3(0.0, 0.0, 1.0), 0.5)
	await tween.finished
	queue_free()
	
func _process(delta):
	# rotate_z spins it like a drill bit. 
	# (If it spins end-over-end like a propeller instead, change rotate_z to rotate_y!)
	
	var outer_mesh = $MeshInstance3D
	var inner_mesh = get_node_or_null("InnerBeam")
	
	# Spin the outer red aura clockwise
	if outer_mesh:
		outer_mesh.rotate_z(15.0 * delta) 
		
	# Spin the inner white core counter-clockwise and faster
	if inner_mesh:
		inner_mesh.rotate_z(-25.0 * delta)
