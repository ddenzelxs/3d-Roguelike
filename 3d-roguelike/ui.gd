# ui.gd
extends CanvasLayer

var wave_manager

@onready var health_label = $HealthLabel
@onready var wave_label = $WaveLabel
@onready var gold_label = $GoldLabel

func _ready():

	var player = get_tree().current_scene.get_node("Player")

	var health_component = player.get_node("HealthComponent")

	health_component.health_changed.connect(_update_health)

	_update_health(health_component.current_health)

	wave_manager = get_tree().current_scene.get_node("WaveManager")

	wave_manager.wave_changed.connect(_update_wave)
	wave_manager.gold_changed.connect(_update_gold)

	_update_wave(wave_manager.current_wave)
	_update_gold(wave_manager.gold)

func _update_health(value):

	health_label.text = "Health: " + str(value)
	
func _update_wave(value):

	wave_label.text = "Wave: " + str(value)
	
func _update_gold(value):

	gold_label.text = "Gold: " + str(value)
