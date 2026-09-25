extends Interactable

func _ready() -> void:
	add_to_group("ground")

func interact() -> void:
	print("ground yes ", name)
	# your logic here

func get_display_name() -> String:
	return "Ground"
