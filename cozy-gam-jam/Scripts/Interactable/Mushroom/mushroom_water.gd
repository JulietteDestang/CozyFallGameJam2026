extends MushroomBase

func can_be_placed_at(pos: Vector3, existing_mushrooms: Array) -> bool:
	print("Check placement pomme - pommes dispo: ", PlayerRessources.get_resource("apple"))
	print("Nombre de existing_mushrooms: ", existing_mushrooms.size())

	if PlayerRessources.get_resource("apple") < 1:
		print("Pas assez de pommes")
		return false

	for mushroom in existing_mushrooms:
		if not is_instance_valid(mushroom):
			continue

		print(" -> test contre ", mushroom.name, " | is Nenuphar: ", mushroom is Nenuphar)

		if mushroom is Nenuphar:
			print("    can_accept_placement: ", mushroom.can_accept_placement())
			if mushroom.can_accept_placement() and mushroom.is_pos_in_zone(pos):
				PlayerRessources.remove_resource("apple")
				return true

	return false
