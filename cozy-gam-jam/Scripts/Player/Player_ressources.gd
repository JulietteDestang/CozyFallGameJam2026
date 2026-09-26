extends Node

var resources: Dictionary = {}
var claimed_resources: Array[Node] = []

signal resources_changed(resources: Dictionary)

func add_resource(resource_type: String, amount: int = 1) -> void:
	if not resources.has(resource_type):
		resources[resource_type] = 0

	resources[resource_type] += amount
	resources_changed.emit(resources)
	
func remove_resource(resource_type: String, amount: int = 1):
	if resources[resource_type] >= 1:
		resources[resource_type] -=1
	resources_changed.emit(resources)
func claim_resource(
	resource: Node,
	resource_type: String,
	amount: int
) -> bool:
	if not is_instance_valid(resource):
		return false

	if resource in claimed_resources:
		return false

	claimed_resources.append(resource)
	add_resource(resource_type, amount)

	resource.queue_free()

	return true

func get_resource(resource_type: String) -> int:
	return resources.get(resource_type, 0)
