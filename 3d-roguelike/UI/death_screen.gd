extends CanvasLayer

@onready var wave_label = $VBoxContainer2/Panel/VBoxContainer/WaveLabel
@onready var level_label = $VBoxContainer2/Panel/VBoxContainer/LevelLabel
@onready var gold_label = $VBoxContainer2/Panel/VBoxContainer/GoldLabel
@onready var kills_label = $VBoxContainer2/Panel/VBoxContainer/KillsLabel

@onready var restart_button = $VBoxContainer2/HBoxContainer/RestartButton
@onready var menu_button = $VBoxContainer2/HBoxContainer/MainMenuButton 

func _ready():
	hide()
	process_mode = Node.PROCESS_MODE_ALWAYS # Anti-beku dari temanmu
	
	restart_button.pressed.connect(_on_restart_pressed)
	menu_button.pressed.connect(_on_main_menu_button_pressed)

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
	get_tree().call_deferred("reload_current_scene")

func _on_main_menu_button_pressed():
	get_tree().paused = false
	get_tree().call_deferred("change_scene_to_file", "res://UI/MainMenu.tscn")
