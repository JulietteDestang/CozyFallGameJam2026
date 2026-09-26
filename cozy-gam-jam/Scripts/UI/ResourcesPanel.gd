extends Panel

@onready var labelIron: Label = $Iron
@onready var labelWater: Label = $Label2
@onready var labelApple: Label = $Label3

var iron_collected: int = 0
var water_collected: int = 0
var apple_collected: int = 0

func _ready() -> void:
	PlayerRessources.resources_changed.connect(_on_resources_changed)
	update_display()

func _on_resources_changed(resources: Dictionary) -> void:
	var total: int = 0

	for amount in resources.values():
		total += amount

	iron_collected = total
	update_display()

func add_iron(amount: int = 1) -> void:
	iron_collected += amount
	update_display()

func update_display() -> void:
	labelIron.text = "💎 Minéraux : " + str(iron_collected)
	labelWater.text = "💧 Water : " + str(water_collected)
	labelApple.text = "🍎 Apple : " + str(apple_collected)
