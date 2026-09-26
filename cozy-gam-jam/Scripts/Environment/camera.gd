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
		var sensitivity := pan_speed * 1
		
		# 1. Axe Droite (X) projeté au sol
		var forward_dir := -global_transform.basis.z
		var right_dir := global_transform.basis.x
		
		# 2. On annule l'inclinaison verticale (Y = 0) et on ré-égalise la longueur (normalize)
		forward_dir.y = 0
		forward_dir = forward_dir.normalized()
		
		right_dir.y = 0
		right_dir = right_dir.normalized()
		
		# 3. Le déplacement vertical de la souris pousse la caméra vers l'avant/arrière au sol
		var motion: Vector3 = (-right_dir * event.relative.x + forward_dir * event.relative.y) * sensitivity		
		# 4. On applique au sol (la hauteur Y reste intacte)
		global_transform.origin += motion
