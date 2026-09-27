extends Node

var mushroom_scenes: Dictionary = {
	"queen": preload("res://Scenes/mushroom_queen.tscn"),
	"simple": preload("res://scenes/mushroom_simple.tscn"),
	"water": preload("res://scenes/mushroom_water.tscn"),
	"explo": preload("res://scenes/mushroom_explo.tscn"),
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

	var existing_mushrooms := parent.get_tree().get_nodes_in_group("mushroom")

	var mushroom = mushroom_scenes[type].instantiate()

	parent.add_child(mushroom)
	mushroom.global_position = Vector3(pos.x, 0, pos.z)
	mushroom.initialize()

	var can_place = mushroom.can_be_placed_at(pos, existing_mushrooms)
	print("can_be_placed_at résultat : ", can_place, " pour type ", type, " à pos ", pos)

	if not can_place:
		print("Impossible de placer ici")
		mushroom.queue_free()
		return

	GlobalSfxController.playMushplacement()
