extends Camera3D

func _ready() -> void:
	# For orthogonal projection
	projection = Camera3D.PROJECTION_ORTHOGONAL
	size = 20  # adjust zoom level
