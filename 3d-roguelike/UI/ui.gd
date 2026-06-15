# ui.gd
extends CanvasLayer

@onready var wave_manager = $"../WaveManager"
@onready var health_label = $StatusBoard/VBoxContainer/HealthLabel
@onready var wave_label = $StatusBoard/VBoxContainer/WaveLabel
@onready var gold_label = $StatusBoard/VBoxContainer/GoldLabel
@onready var xp_bar = $XpBar
@onready var xp_text = $XpBar/XpText

@onready var player = get_tree().current_scene.get_node("Player")

func _ready():
	var health_component = player.get_node("Component/Health")
	var gold_component = player.get_node("Component/Gold")
	var xp_component = player.get_node("Component/Xp")
	
	health_component.health_changed.connect(_update_health)
	gold_component.gold_changed.connect(_update_gold)
	xp_component.xp_changed.connect(_update_xp)

	_update_health(health_component.current_health)
	_update_gold(gold_component.gold)

	_update_wave(wave_manager.current_wave)
	
	xp_bar.max_value = player.threshold_level
	
	_update_xp(xp_component.xp)
	
func _update_health(value):
	health_label.text = "Health: " + str(value)
	
func _update_wave(value):
	wave_label.text = "Wave: " + str(value)
	
func _update_gold(value):
	gold_label.text = "Gold: " + str(value)

func _update_xp(value):
	xp_bar.max_value = player.threshold_level
	xp_bar.value = value
	
	var percentage = round((float(value) / float(player.threshold_level)) * 100)
	xp_text.text = str(percentage) + "%"
	# xp_text.text = str(value) + " / " + str(player.threshold_level)
