extends Node

signal gold_changed(gold)

var gold : float

func _ready():
	gold = 0

func add_gold(amount : int):
	gold += amount
	gold_changed.emit(gold)
