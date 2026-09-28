extends MushroomBase

func can_be_placed_at(pos: Vector3, existing_mushrooms: Array) -> bool:
	for mushroom in existing_mushrooms:
		if not is_instance_valid(mushroom):
			continue

		if mushroom.get_script() == get_script():
			print("Ce champignon ne peut être placé qu'une seule fois")
			return false

	return true
