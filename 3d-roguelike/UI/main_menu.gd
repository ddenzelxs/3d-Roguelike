extends Control

func _ready() -> void:
	get_tree().paused = false

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://root.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()
