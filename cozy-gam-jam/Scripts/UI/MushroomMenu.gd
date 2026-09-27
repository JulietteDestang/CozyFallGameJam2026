extends HBoxContainer

@onready var button_queen: Button = $button_queen
@onready var button_simple: Button = $button_simple
@onready var button_water: Button = $button_water
@onready var button_explo: Button = $button_explo

func _ready() -> void:
	button_queen.pressed.connect(_on_mushroom_selected.bind("queen"))
	button_simple.pressed.connect(_on_mushroom_selected.bind("simple"))
	button_water.pressed.connect(_on_mushroom_selected.bind("water"))
	button_explo.pressed.connect(_on_mushroom_selected.bind("explo"))
	_update_button_highlight()

func _on_mushroom_selected(type: String) -> void:
	MushroomManager.set_selected_mushroom(type)
	GlobalSfxController.playClick()
	_update_button_highlight()

func _update_button_highlight() -> void:
	button_queen.disabled = (MushroomManager.selected_mushroom == "queen")
	button_simple.disabled = (MushroomManager.selected_mushroom == "simple")
	button_water.disabled = (MushroomManager.selected_mushroom == "water")
	button_explo.disabled = (MushroomManager.selected_mushroom == "explo")
