extends Node

signal died
signal health_changed(current_health)

@export var max_health := 100

var current_health : int

func _ready():
	current_health = max_health
	health_changed.emit(current_health)

func take_damage(amount : int):

	current_health -= amount

	health_changed.emit(current_health)

	if current_health <= 0:
		died.emit()
