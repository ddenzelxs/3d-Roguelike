extends Node3D

@onready var animation = $"Sketchfab_Scene/AnimationPlayer"
@onready var shop_menu = get_tree().current_scene.get_node("ShopMenu")
@onready var prompt = $InteractPrompt  # <--- Add reference to your new label

var player_in_range = false

func _ready() -> void:
	animation.stop() 
	$InteractArea.body_entered.connect(_on_body_entered)
	$InteractArea.body_exited.connect(_on_body_exited)

func _process(_delta: float) -> void:
	if player_in_range and Input.is_action_just_pressed("attack"):
		open_chest()

func _on_body_entered(body: Node3D):
	if body.is_in_group("player"):
		player_in_range = true
		prompt.visible = true  # <--- Show the prompt

func _on_body_exited(body: Node3D):
	if body.is_in_group("player"):
		player_in_range = false
		prompt.visible = false # <--- Hide the prompt

func open_chest():
	player_in_range = false
	prompt.visible = false # <--- Hide it immediately when opened
	$InteractArea.monitoring = false 
	
	animation.play("Take 001")
	#await animation.animation_finished
	shop_menu.open_shop(self)
