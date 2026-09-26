extends StaticBody3D
class_name MushroomBase

@export var circle_zone_scene: PackedScene
@export var spawn_interval: float = 3.0
@export var new_circle_radius: float = 1.0
@export var new_circle_grow_duration: float = 100.0
@export var max_circles: int = 5

var circles: Array = []

var initialized := false

func _ready() -> void:
	add_to_group("interactable")
	add_to_group("mushroom")


func initialize() -> void:
	if initialized:
		return

	initialized = true
	_spawn_circle_at(global_position)
	_start_spawn_loop()

func _start_spawn_loop() -> void:
	while true:
		await get_tree().create_timer(spawn_interval).timeout
		if circles.size() >= max_circles:
			break
		_spawn_new_edge_circle()

func _spawn_new_edge_circle() -> void:
	circles = circles.filter(func(c): return is_instance_valid(c))

	if circles.size() >= max_circles or circles.is_empty():
		return

	var base_circle = circles[randi() % circles.size()]
	var base_radius: float = base_circle.get_visual_radius()
	var valid_positions: Array[Vector3] = []

	for i in 60:
		var angle: float = randf() * TAU
		var direction: Vector3 = Vector3(cos(angle), 0.0, sin(angle))
		var pos: Vector3 = base_circle.global_position + direction * base_radius

		if _get_total_overlap(pos, new_circle_radius, base_circle) < 50.0:
			valid_positions.append(pos)

	if not valid_positions.is_empty():
		var chosen_position: Vector3 = valid_positions[randi() % valid_positions.size()]
		_spawn_circle_at(chosen_position)
	else:
		var angle: float = randf() * TAU
		var direction: Vector3 = Vector3(cos(angle), 0.0, sin(angle))
		var fallback_position: Vector3 = base_circle.global_position + direction * base_radius
		_spawn_circle_at(fallback_position)

func _get_total_overlap(pos: Vector3, new_radius: float, base_circle) -> float:
	var total_overlap: float = 0.0

	for circle in circles:
		if not is_instance_valid(circle) or circle == base_circle:
			continue

		var distance: float = Vector2(
			pos.x - circle.global_position.x,
			pos.z - circle.global_position.z
		).length()

		var minimum_distance: float = new_radius + circle.get_visual_radius()

		if distance < minimum_distance:
			total_overlap += minimum_distance - distance

	return total_overlap

func _spawn_circle_at(pos: Vector3) -> void:
	if circles.size() >= max_circles:
		return

	if circle_zone_scene == null:
		push_warning("circle_zone_scene n'est pas assigné.")
		return

	var circle = circle_zone_scene.instantiate()
	add_child(circle)

	circle.global_position = pos
	circle.target_radius = new_circle_radius
	circle.grow_duration = new_circle_grow_duration
	circle.mushroom = self

	circles.append(circle)

func is_pos_in_zone(pos: Vector3) -> bool:
	for circle in circles:
		if not is_instance_valid(circle):
			continue

		var center: Vector2 = Vector2(
			circle.global_position.x,
			circle.global_position.z
		)

		var position: Vector2 = Vector2(pos.x, pos.z)

		if center.distance_to(position) <= circle.get_visual_radius():
			return true

	return false

func can_be_placed_at(pos: Vector3, existing_mushrooms: Array) -> bool:
	return true

func interact() -> void:
	print("Mushroom cliqué: ", name)
