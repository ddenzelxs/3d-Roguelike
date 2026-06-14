extends CanvasLayer

@onready var wave_label = $Panel/VBoxContainer/WaveLabel
@onready var level_label = $Panel/VBoxContainer/LevelLabel
@onready var gold_label = $Panel/VBoxContainer/GoldLabel
@onready var kills_label = $Panel/VBoxContainer/KillsLabel
@onready var restart_button = $Panel/VBoxContainer/RestartButton

func _ready():
	hide()
	process_mode = Node.PROCESS_MODE_ALWAYS
	restart_button.pressed.connect(_on_restart_pressed)

func show_death_screen(wave: int, level: int, gold: int, kills: int):
	wave_label.text = "Wave Reached: " + str(wave)
	level_label.text = "Level: " + str(level)
	gold_label.text = "Gold Earned: " + str(gold)
	kills_label.text = "Enemies Killed: " + str(kills)

	show()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = true

func _on_restart_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
