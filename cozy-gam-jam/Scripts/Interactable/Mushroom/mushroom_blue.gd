extends MushroomBase

func can_be_placed_at(pos: Vector3, existing_mushrooms: Array) -> bool:
	if not PlayerRessources.get_resource("Iron") >= 1:
		return false;
	for mushroom in existing_mushrooms:
		if not is_instance_valid(mushroom):
			continue
		var dist = mushroom.global_position.distance_to(pos)
		if dist <= mushroom.get_current_radius():
			return true
	return false
