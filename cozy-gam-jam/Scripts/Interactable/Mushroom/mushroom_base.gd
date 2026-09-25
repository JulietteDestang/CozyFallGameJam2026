extends StaticBody3D
class_name MushroomBase

@onready var growing_radius: Area3D = $GrowingRadius

var resources_in_range: Array = []


func _ready() -> void:
	add_to_group("interactable")
	add_to_group("mushroom")

	growing_radius.body_entered.connect(_on_resource_entered)
	growing_radius.body_exited.connect(_on_resource_exited)


func get_current_radius() -> float:
	return growing_radius.current_radius


func can_be_placed_at(pos: Vector3, existing_mushrooms: Array) -> bool:
	return true


func interact() -> void:
	print("Mushroom cliqué: ", name)


func _on_resource_entered(body: Node3D) -> void:
	if not body.is_in_group("resource"):
		return

	# Le minéral appartient déjà à un autre champignon
	if body.owner_mushroom != null:
		return

	body.owner_mushroom = self

	if not resources_in_range.has(body):
		resources_in_range.append(body)
		print("💎 ", body.name, " appartient maintenant à ", name)

func _on_resource_exited(body: Node3D) -> void:
	if body.is_in_group("resource"):
		resources_in_range.erase(body)
		print(body.name, " sort de ", name)
