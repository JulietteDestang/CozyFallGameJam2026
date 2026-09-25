extends Node

var minerals: int = 0

signal minerals_changed(new_amount: int)

func add_minerals(amount: int) -> void:
	minerals += amount
	minerals_changed.emit(minerals)
