extends Node

signal xp_changed(xp)

var xp : int

func _ready():
	xp = 0

func add_xp(amount : int):
	xp += amount
	xp_changed.emit(xp)

func remove_xp(amount: int):
	xp -= amount
	xp_changed.emit(xp)
