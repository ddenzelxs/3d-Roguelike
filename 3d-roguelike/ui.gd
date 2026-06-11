# ui.gd
extends CanvasLayer

@onready var wave_manager = $"../WaveManager"
@onready var health_label = $HealthLabel
@onready var wave_label = $WaveLabel
@onready var gold_label = $GoldLabel

func _ready():
	var player = get_tree().current_scene.get_node("Player")
	var health_component = player.get_node("Component/Health")
	var gold_component = player.get_node("Component/Gold")
	health_component.health_changed.connect(_update_health)
	gold_component.gold_changed.connect(_update_gold)

	_update_health(health_component.current_health)
	_update_gold(gold_component.gold)

	_update_wave(wave_manager.current_wave)

func _update_health(value):
	health_label.text = "Health: " + str(value)
	
func _update_wave(value):
	wave_label.text = "Wave: " + str(value)
	
func _update_gold(value):
	gold_label.text = "Gold: " + str(value)
