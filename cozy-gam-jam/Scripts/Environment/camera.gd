extends Camera3D

@export var pan_speed : float = 0.010
@export var zoom_speed : float = 1.5
@export var min_zoom_height : float = 3.0
@export var max_zoom_height : float = 6.0
@export var smoothzoom : float = 6.0
@export var max_pan_distance : float = 100.0
@export var min_pan_ratio : float = 0.2

var is_panning : bool = false
var target_position : Vector3
var start_position : Vector3

func _ready() -> void:
	target_position = global_transform.origin
	start_position = global_transform.origin

func _process(delta: float) -> void:
	global_transform.origin = global_transform.origin.lerp(target_position, smoothzoom * delta)
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_MIDDLE:
			is_panning = event.pressed
			
		if event.pressed:
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				_zoom_camera(-zoom_speed)
			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				_zoom_camera(zoom_speed)
	
	if event is InputEventMouseMotion and is_panning:
		var zoom_factor := remap(target_position.y, min_zoom_height, max_zoom_height, 1.0, min_pan_ratio)
		var sensitivity := pan_speed * zoom_factor
		
		var forward_dir := -global_transform.basis.z
		var right_dir := global_transform.basis.x
		
		forward_dir.y = 0
		forward_dir = forward_dir.normalized()
		
		right_dir.y = 0
		right_dir = right_dir.normalized()
		
		var motion: Vector3 = (-right_dir * event.relative.x + forward_dir * event.relative.y) * sensitivity		
		
		target_position += motion
		
		var offset = target_position - start_position
		var current_target_y = target_position.y 
		offset.y = 0 
		if offset.length() > max_pan_distance:
			offset = offset.limit_length(max_pan_distance)
		target_position = Vector3(start_position.x + offset.x, current_target_y, start_position.z + offset.z)

func _zoom_camera(amount: float) -> void:
	
	var motion = global_transform.basis.z * amount
	var proposed_position = target_position + motion
	
	if proposed_position.y >= min_zoom_height and proposed_position.y <= max_zoom_height:
		target_position = proposed_position
