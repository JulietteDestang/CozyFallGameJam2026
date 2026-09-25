extends Interactable

func _ready() -> void:
	add_to_group("interactable")

func interact() -> void:
	print("interact yes ", name)
	# your logic here

func get_display_name() -> String:
	return "Mushroom"
