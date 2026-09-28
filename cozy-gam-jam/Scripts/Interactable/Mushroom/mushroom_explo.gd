extends MushroomBase 

@onready var detection_area: Area3D = $Area3D

func initialize() -> void:
	super.initialize()
	_start_destruction_timer()

func can_be_placed_at(pos: Vector3, existing_mushrooms: Array) -> bool:
	
	if PlayerRessources.get_resource("iron") < 1:
		return false


	for mushroom in existing_mushrooms:
		if not is_instance_valid(mushroom):
			continue
		var in_zone = mushroom.is_pos_in_zone(pos)
		print("Mushroom ", mushroom.name, " - in_zone: ", in_zone)
		if in_zone:
			PlayerRessources.remove_resource("iron")
			return true

	return false

func _start_destruction_timer() -> void:
	await get_tree().create_timer(3.0).timeout

	# Supprime tous les blocks présents dans la zone au moment de l'explosion
	for body in detection_area.get_overlapping_bodies():
		if body.is_in_group("explode") and is_instance_valid(body):
			print("BLOCK DÉTRUIT : ", body.name)
			body.queue_free()

	# Supprime le champignon
	if is_inside_tree():	
		GlobalSfxController.playMushboom()
		queue_free()
