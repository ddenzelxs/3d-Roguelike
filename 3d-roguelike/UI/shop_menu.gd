extends CanvasLayer

@onready var container = $Panel/VBoxContainer
@onready var title_label = $Panel/VBoxContainer/Label

var player
var current_items: Array[Dictionary] = []
var chest_reference: Node3D = null

func _ready():
	hide()
	player = get_tree().current_scene.get_node("Player")
	title_label.text = "Merchant Chest"

func open_shop(chest: Node3D):
	chest_reference = chest
	
	# Clear old buttons (except title)
	for child in container.get_children():
		if child != title_label:
			child.queue_free()

	current_items = UpgradeData.get_random_upgrades(3)

	for item in current_items:
		var button = Button.new()
		# Add the cost to the button text
		button.text = item.name + " (" + str(item.cost) + " Gold)\n" + item.description
		button.custom_minimum_size = Vector2(400, 60)

		var color = UpgradeData.get_rarity_color(item.rarity)
		button.add_theme_color_override("font_color", color)
		button.add_theme_color_override("font_hover_color", color.lightened(0.3))

		button.pressed.connect(_on_item_selected.bind(item))
		container.add_child(button)
		
	# Add a leave button so players aren't forced to buy
	var close_btn = Button.new()
	close_btn.text = "Leave (Keep Gold)"
	close_btn.custom_minimum_size = Vector2(400, 40)
	close_btn.pressed.connect(close_shop)
	container.add_child(close_btn)

	show()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = true

func close_shop():
	hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().paused = false

func _on_item_selected(item: Dictionary):
	var gold_component = player.get_node("Component/Gold")
	
	if gold_component.spend_gold(item.cost):
		player.apply_upgrade(item)
		if chest_reference:
			chest_reference.queue_free() # Make chest disappear after buying
		close_shop()
	else:
		print("Not enough gold!") # You can change button text to "Not enough gold!" instead later
