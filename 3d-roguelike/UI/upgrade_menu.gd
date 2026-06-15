extends CanvasLayer

@onready var container = $NinePatchRect/VBoxContainer
@onready var title_label = $NinePatchRect/VBoxContainer/Label

var player
var current_upgrades: Array[Dictionary] = []

@export var transisi_scene: PackedScene
func _ready():
	hide()
	player = get_tree().current_scene.get_node("Player")

func show_menu():
	get_tree().paused = true
	
	if transisi_scene != null:
		var efek = transisi_scene.instantiate()
		add_child(efek) 
	
		await get_tree().create_timer(1).timeout
		
		efek.queue_free()
	# Clear old buttons (keep the title label)
	for child in container.get_children():
		if child != title_label:
			child.queue_free()

	# Pick 3 random upgrades
	current_upgrades = UpgradeData.get_random_upgrades(3)

	# Create a button for each
	for upgrade in current_upgrades:
		var button = Button.new()
		button.text = upgrade.name + "\n" + upgrade.description
		button.custom_minimum_size = Vector2(400, 60)

		# Color the text by rarity
		var color = UpgradeData.get_rarity_color(upgrade.rarity)
		button.add_theme_color_override("font_color", color)
		button.add_theme_color_override("font_hover_color", color.lightened(0.3))

		button.pressed.connect(_on_upgrade_selected.bind(upgrade))
		container.add_child(button)

	show()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = true

func hide_menu():
	hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().paused = false

func _on_upgrade_selected(upgrade: Dictionary):
	player.apply_upgrade(upgrade)
	hide_menu()
