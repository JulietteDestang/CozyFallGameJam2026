extends Node

var mushroom_scenes: Dictionary = {
	"brown": preload("res://scenes/mushroom_brown.tscn"),
	"blue": preload("res://scenes/mushroom_blue.tscn"),
}

var selected_mushroom: String = "brown"
var active_mushrooms: Array = []

func set_selected_mushroom(type: String) -> void:
	if not mushroom_scenes.has(type):
		push_warning("Type de champignon inconnu: " + type)
		return
	selected_mushroom = type

func spawn_mushroom(type: String, pos: Vector3, parent: Node) -> void:
	if not mushroom_scenes.has(type):
		push_warning("Type de champignon inconnu: " + type)
		return

	# Nettoie la liste des instances invalides (détruites)
	active_mushrooms = active_mushrooms.filter(func(m): return is_instance_valid(m))

	var mushroom = mushroom_scenes[type].instantiate()

	parent.add_child(mushroom)
	mushroom.global_position = pos
	mushroom.initialize()

	if not mushroom.can_be_placed_at(pos, active_mushrooms):
		print("Impossible de placer ici")
		mushroom.queue_free()
		return
		
	GlobalSfxController.playMushplacement()

	active_mushrooms.append(mushroom)
