extends Area3D
class_name GrowingRadius

@export var max_radius: float = 50.0
@export var growth_step: float = 0.1
@export var interval_seconds: float = 3.0
@export var indicator_path: NodePath = "../RadiusIndicator"

@onready var radius_indicator: MeshInstance3D = get_node(indicator_path)
@onready var collision_shape: CollisionShape3D = $CollisionShape3D

var current_radius: float = 1.0


func _ready() -> void:
	_update_radius()
	_start_growth_loop()


func _start_growth_loop() -> void:
	while current_radius < max_radius:
		await get_tree().create_timer(interval_seconds).timeout
		
		current_radius = min(current_radius + growth_step, max_radius)
		_animate_to_current_radius()


func _update_radius() -> void:
	# Visuel
	radius_indicator.scale = Vector3(current_radius, 1.0, current_radius)

	# Collision
	var cylinder := collision_shape.shape as CylinderShape3D
	if cylinder:
		cylinder.radius = current_radius


func _animate_to_current_radius() -> void:
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)

	tween.tween_property(
		radius_indicator,
		"scale",
		Vector3(current_radius, 1.0, current_radius),
		0.1
	)

	# On met aussi le collider à jour
	_update_radius()
