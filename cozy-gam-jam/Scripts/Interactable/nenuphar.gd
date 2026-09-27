extends MushroomBase
class_name Nenuphar

@export var placement_tolerance: float = 0.3
@export var activated_color: Color = Color.GREEN

@onready var detection_area: Area3D = $Area3D
@onready var mesh_instance: MeshInstance3D = $MeshInstance3D

var is_active := false

func _ready() -> void:
	super._ready()
	initialize()

func initialize() -> void:
	if initialized:
		return
	initialized = true
	print("Nénuphar initialize() appelé : ", name)

	detection_area.area_entered.connect(_on_area_entered)
	detection_area.body_entered.connect(_on_body_entered)

	call_deferred("_check_already_overlapping")

func _check_already_overlapping() -> void:
	await get_tree().physics_frame
	await get_tree().physics_frame

	for area in detection_area.get_overlapping_areas():
		_on_area_entered(area)
	for body in detection_area.get_overlapping_bodies():
		_on_body_entered(body)

func _on_area_entered(area: Area3D) -> void:
	if area.is_in_group("red_zone") and not is_active:
		_activate()

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("red_zone") and not is_active:
		_activate()

func _activate() -> void:
	is_active = true
	print("NÉNUPHAR ACTIVÉ : ", name)

	var mat := StandardMaterial3D.new()
	mat.albedo_color = activated_color
	mesh_instance.material_override = mat

func is_pos_in_zone(pos: Vector3) -> bool:
	if not is_active:
		return false
	var center: Vector2 = Vector2(global_position.x, global_position.z)
	var position: Vector2 = Vector2(pos.x, pos.z)
	return center.distance_to(position) <= placement_tolerance

func can_be_placed_at(pos: Vector3, existing_mushrooms: Array) -> bool:
	return false

func can_accept_placement() -> bool:
	return is_active
