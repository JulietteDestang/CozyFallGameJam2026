extends HBoxContainer

@onready var labelIron: Label = $VBoxContainer2/HBoxContainer/Iron
@onready var labelWater: Label = $VBoxContainer2/HBoxContainer2/Label2
@onready var labelApple: Label = $VBoxContainer2/HBoxContainer3/Label3

var iron_collected: int = 0
var water_collected: int = 0
var apple_collected: int = 0

func _ready() -> void:
	PlayerRessources.resources_changed.connect(_on_resources_changed)
	update_display()

func _on_resources_changed(resources: Dictionary) -> void:
	var total: int = 0

	iron_collected = resources.get("iron", 0)
	apple_collected = resources.get("apple", 0)

	update_display()
	

func update_display() -> void:
	labelIron.text = "Minéraux : " + str(iron_collected)
	labelWater.text = "Water : " + str(water_collected)
	labelApple.text = "Apple : " + str(apple_collected)
