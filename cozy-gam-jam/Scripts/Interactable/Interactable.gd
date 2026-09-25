extends StaticBody3D
class_name Interactable

## Override this in scripts that extend Interactable
func interact() -> void:
	push_warning("interact() not implemented on: " + name)

## Override this too, for tooltips/UI
func get_display_name() -> String:
	return name
