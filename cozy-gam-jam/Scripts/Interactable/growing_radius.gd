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
		var next_radius: float = min(
			current_radius + growth_step,
			max_radius
		)

		var tween := create_tween()
		tween.set_trans(Tween.TRANS_SINE)
		tween.set_ease(Tween.EASE_IN_OUT)

		# Animation du visuel
		tween.parallel().tween_property(
			radius_indicator,
			"scale",
			Vector3(next_radius, 1.0, next_radius),
			interval_seconds
		)

		# Animation du collider
		var cylinder := collision_shape.shape as CylinderShape3D

		if cylinder:
			tween.parallel().tween_method(
				_set_collision_radius,
				current_radius,
				next_radius,
				interval_seconds
			)

		await tween.finished

		current_radius = next_radius


func _set_collision_radius(radius: float) -> void:
	var cylinder := collision_shape.shape as CylinderShape3D

	if cylinder:
		cylinder.radius = radius


func _update_radius() -> void:
	# Visuel
	radius_indicator.scale = Vector3(
		current_radius,
		1.0,
		current_radius
	)

	# Collision
	_set_collision_radius(current_radius)
