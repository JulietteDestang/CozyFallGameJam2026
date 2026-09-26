extends Area3D
class_name CircleZone

@export var target_radius: float = 1.0
@export var grow_duration: float = 3.0
@export var outline_y: float = 0.01

@onready var mesh_instance: MeshInstance3D = $MeshInstance3D
@onready var collision_shape: CollisionShape3D = $CollisionShape3D

var current_radius: float = 0.05

# Référence vers le MushroomBase auquel appartient ce cercle.
var mushroom: MushroomBase

var outline_mesh: ImmediateMesh
var outline_instance: MeshInstance3D


func _ready() -> void:
	body_entered.connect(_on_body_entered)

	_create_outline()

	_update_zone()

	var tween := create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)

	tween.tween_method(
		_update_radius,
		current_radius,
		target_radius,
		grow_duration
	)


func _update_radius(value: float) -> void:
	current_radius = value

	_update_zone()
	_update_all_outlines()


func _update_zone() -> void:
	mesh_instance.scale = Vector3(
		current_radius,
		1.0,
		current_radius
	)

	if collision_shape.shape is CylinderShape3D:
		var cylinder := collision_shape.shape as CylinderShape3D

		cylinder.radius = current_radius
		cylinder.height = 2.0


# =========================================================
# CONTOUR GLOBAL
# =========================================================

func _create_outline() -> void:
	outline_mesh = ImmediateMesh.new()

	outline_instance = MeshInstance3D.new()
	outline_instance.mesh = outline_mesh

	var material := StandardMaterial3D.new()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color("#7A0000")
	material.no_depth_test = true

	outline_instance.material_override = material

	add_child(outline_instance)


func _update_all_outlines() -> void:
	if mushroom == null:
		return

	for circle in mushroom.circles:
		if not is_instance_valid(circle):
			continue

		if circle is CircleZone:
			circle._update_outline()


func _update_outline() -> void:
	if outline_mesh == null:
		return

	outline_mesh.clear_surfaces()

	var circles: Array = _get_mushroom_circles()

	if circles.is_empty():
		return

	var segments: int = 256

	var exposed: Array[bool] = []

	for i in range(segments):
		var angle: float = TAU * float(i) / float(segments)

		var local_point := Vector3(
			cos(angle) * get_visual_radius(),
			outline_y,
			sin(angle) * get_visual_radius()
		)

		var world_point: Vector3 = to_global(local_point)

		var is_inside_another_circle: bool = false

		for other in circles:
			if other == self:
				continue

			var other_radius: float = other.get_visual_radius()

			var distance: float = Vector2(
				world_point.x - other.global_position.x,
				world_point.z - other.global_position.z
			).length()

			if distance < other_radius:
				is_inside_another_circle = true
				break

		exposed.append(not is_inside_another_circle)

	_draw_exposed_arcs(exposed, segments)


func _draw_exposed_arcs(
	exposed: Array[bool],
	segments: int
) -> void:

	var current_run: Array[Vector3] = []
	var runs: Array = []

	for i in range(segments):
		if exposed[i]:
			var angle: float = TAU * float(i) / float(segments)

			var local_point := Vector3(
				cos(angle) * get_visual_radius(),
				outline_y,
				sin(angle) * get_visual_radius()
			)

			current_run.append(local_point)

		else:
			if current_run.size() >= 2:
				runs.append(current_run)

			current_run = []


	# Dernier morceau
	if current_run.size() >= 2:
		runs.append(current_run)


	# Si le contour traverse l'angle 0,
	# on reconnecte le début et la fin.
	if runs.size() >= 2:
		if exposed[0] and exposed[segments - 1]:
			var first_run: Array = runs[0]
			var last_run: Array = runs[runs.size() - 1]

			var merged_run: Array[Vector3] = []

			for point in last_run:
				merged_run.append(point)

			for point in first_run:
				merged_run.append(point)

			runs[0] = merged_run
			runs.remove_at(runs.size() - 1)


	for run in runs:
		if run.size() < 2:
			continue

		outline_mesh.surface_begin(Mesh.PRIMITIVE_LINE_STRIP)

		for point in run:
			outline_mesh.surface_add_vertex(point)

		outline_mesh.surface_end()


func _get_mushroom_circles() -> Array:
	var result: Array = []

	if mushroom == null:
		return result

	for circle in mushroom.circles:
		if not is_instance_valid(circle):
			continue

		if circle is CircleZone:
			result.append(circle)

	return result


# =========================================================
# RAYON
# =========================================================

func get_visual_radius() -> float:
	if mesh_instance.mesh == null:
		return current_radius

	var mesh_radius: float = mesh_instance.mesh.get_aabb().size.x * 0.5

	return mesh_radius * current_radius


# =========================================================
# RESSOURCES
# =========================================================

func _on_body_entered(body: Node3D) -> void:
	if not body.is_in_group("resource"):
		return

	var resource_type: String = body.resource_type
	var resource_amount: int = body.resource_amount

	if PlayerRessources.claim_resource(
		body,
		resource_type,
		resource_amount
	):
		print(
			mushroom.name,
			" a récupéré ",
			resource_amount,
			" x ",
			resource_type
		)
