extends Node

var mushroom_scenes: Dictionary = {
	"brown": preload("res://Scenes/mushroom_brown.tscn"),
	"red": preload("res://Scenes/mushroom_red.tscn"),
}

var selected_mushroom: String = "brown"

func set_selected_mushroom(type: String) -> void:
	if not mushroom_scenes.has(type):
		push_warning("Type de champignon inconnu: " + type)
		return
	selected_mushroom = type
	print("Champignon sélectionné: ", type)

func spawn_mushroom(type: String, pos: Vector3, parent: Node) -> void:
	if not mushroom_scenes.has(type):
		push_warning("Type de champignon inconnu: " + type)
		return
	var mushroom = mushroom_scenes[type].instantiate()
	parent.add_child(mushroom)
	mushroom.global_position = pos
