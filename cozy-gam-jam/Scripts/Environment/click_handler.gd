extends Node3D

@onready var camera: Camera3D = $Camera3D

var hovered_mushroom: MushroomBase = null


func _process(_delta: float) -> void:
	_update_mouse_hover()


func _update_mouse_hover() -> void:
	var mouse_pos = get_viewport().get_mouse_position()

	var ray_origin = camera.project_ray_origin(mouse_pos)
	var ray_dir = camera.project_ray_normal(mouse_pos)
	var ray_end = ray_origin + ray_dir * 1000

	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)

	var result = space_state.intersect_ray(query)

	var mushroom: MushroomBase = null

	if result:
		var collider = result.collider

		if collider is MushroomBase:
			mushroom = collider

	# On est passé sur un autre champignon
	if mushroom != hovered_mushroom:

		# Cacher l'ancienne bulle
		if hovered_mushroom != null:
			hovered_mushroom.hide_resource_bubble()

		hovered_mushroom = mushroom

		# Afficher la nouvelle
		if hovered_mushroom != null:
			hovered_mushroom.show_resource_bubble()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton \
	and event.pressed \
	and event.button_index == MOUSE_BUTTON_LEFT:

		var mouse_pos = get_viewport().get_mouse_position()
		var ray_origin = camera.project_ray_origin(mouse_pos)
		var ray_dir = camera.project_ray_normal(mouse_pos)
		var ray_end = ray_origin + ray_dir * 1000

		var space_state = get_world_3d().direct_space_state
		var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
		var result = space_state.intersect_ray(query)

		if result:
			_handle_click(result.collider, result.position)


func _handle_click(collider: Node, world_pos: Vector3) -> void:
	if collider.is_in_group("interactable"):
		if collider.has_method("interact"):
			collider.interact()

	elif collider.is_in_group("ground"):
		MushroomManager.spawn_mushroom(
			MushroomManager.selected_mushroom,
			world_pos,
			self
		)
