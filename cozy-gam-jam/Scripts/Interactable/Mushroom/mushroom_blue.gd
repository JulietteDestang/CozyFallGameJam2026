extends MushroomBase

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
