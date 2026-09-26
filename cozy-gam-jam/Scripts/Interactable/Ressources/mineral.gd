extends StaticBody3D

@export var resource_type: String = "iron"
@export var resource_amount: int = 1

func _ready() -> void:
	add_to_group("resource")
