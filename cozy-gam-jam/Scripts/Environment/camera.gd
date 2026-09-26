extends Camera3D

@export var pan_speed : float = 2.0
var is_panning : bool = false

#func _ready() -> void:
	# For orthogonal projection
	#projection = Camera3D.PROJECTION_ORTHOGONAL
	#size = 20  # adjust zoom level

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_MIDDLE:
			is_panning = event.pressed
	
	if event is InputEventMouseMotion and is_panning:
		var delta_movement = Vector3(-event.relative.x, 0, -event.relative.y) * (pan_speed * 0.05)
		
		global_transform.origin += global_transform.basis * Vector3(-event.relative.x, event.relative.y, 0) * (pan_speed * 0.005)
