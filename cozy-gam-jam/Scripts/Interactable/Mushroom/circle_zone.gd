extends Area3D
class_name CircleZone

@export var target_radius: float = 1.4
@export var grow_duration: float = 4.0
@export var outline_y: float = 0.01

@onready var mesh_instance: MeshInstance3D = $MeshInstance3D
@onready var collision_shape: CollisionShape3D = $CollisionShape3D

var current_radius: float = 0.05
var mushroom: MushroomBase

var growth_tween: Tween
var is_blocked: bool = false


func _ready() -> void:
	add_to_group("red_zone")
	print("CircleZone layer=", collision_layer, " mask=", collision_mask, " monitorable=", monitorable)
	# Duplique le shape pour que CE cercle ait sa propre instance, indépendante des autres
	if collision_shape.shape is CylinderShape3D:
		collision_shape.shape = collision_shape.shape.duplicate()

	body_entered.connect(_on_body_entered)

	_update_zone()

	growth_tween = create_tween()
	growth_tween.set_trans(Tween.TRANS_SINE)
	growth_tween.set_ease(Tween.EASE_OUT)

	growth_tween.tween_method(
		_update_radius,
		current_radius,
		target_radius,
		grow_duration
	)


func _update_radius(value: float) -> void:
	if is_blocked:
		return  # ignore toute mise à jour une fois bloqué

	current_radius = value
	_update_zone()


func _update_zone() -> void:
	mesh_instance.scale = Vector3(current_radius, 1.0, current_radius)

	if collision_shape.shape is CylinderShape3D:
		var cylinder := collision_shape.shape as CylinderShape3D
		cylinder.radius = current_radius
		cylinder.height = 2.0


func _stop_growth() -> void:
	if is_blocked:
		return

	is_blocked = true

	if growth_tween and growth_tween.is_valid():
		growth_tween.kill()

	print(mushroom.name if mushroom else name, " - croissance stoppée par un obstacle")


func get_visual_radius() -> float:
	if mesh_instance.mesh == null:
		return current_radius

	var mesh_radius: float = mesh_instance.mesh.get_aabb().size.x * 0.5
	return mesh_radius * current_radius


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("block") or body.is_in_group("nospawn"):
		_stop_growth()
		return

	if body.is_in_group("resource"):
		var resource_type: String = body.resource_type
		var resource_amount: int = body.resource_amount

		if PlayerRessources.claim_resource(body, resource_type, resource_amount):
			print(mushroom.name, " a récupéré ", resource_amount, " x ", resource_type)
