extends Node
class_name GrowingRadius

@export var max_radius: float = 5.0
@export var growth_step: float = 0.1       # de combien le rayon augmente à chaque palier
@export var interval_seconds: float = 3.0  # attente entre chaque palier
@export var indicator_path: NodePath = "../RadiusIndicator"

@onready var radius_indicator: MeshInstance3D = get_node(indicator_path)

var current_radius: float = 0.5

func _ready() -> void:
	radius_indicator.scale = Vector3(current_radius, 1.0, current_radius)
	_start_growth_loop()

func _start_growth_loop() -> void:
	while current_radius < max_radius:
		await get_tree().create_timer(interval_seconds).timeout
		current_radius = min(current_radius + growth_step, max_radius)
		_animate_to_current_radius()

func _animate_to_current_radius() -> void:
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(
		radius_indicator,
		"scale",
		Vector3(current_radius, 1.0, current_radius),
		0.5  # durée courte de la transition visuelle entre chaque palier
	)
