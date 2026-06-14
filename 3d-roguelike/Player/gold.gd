extends Node

signal gold_changed(gold)

var gold : int

func _ready():
	gold = 0

func add_gold(amount : int):
	gold += amount
	gold_changed.emit(gold)
	
func spend_gold(amount: int) -> bool:
	if gold >= amount:
		gold -= amount
		gold_changed.emit(gold)
		return true
	return false
