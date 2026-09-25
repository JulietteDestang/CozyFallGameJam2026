extends HBoxContainer

@onready var button_brown: Button = $ButtonBrown
@onready var button_blue: Button = $ButtonBlue

func _ready() -> void:
	button_brown.pressed.connect(_on_mushroom_selected.bind("brown"))
	button_blue.pressed.connect(_on_mushroom_selected.bind("blue"))
	_update_button_highlight()

func _on_mushroom_selected(type: String) -> void:
	MushroomManager.set_selected_mushroom(type)
	_update_button_highlight()

func _update_button_highlight() -> void:
	button_brown.disabled = (MushroomManager.selected_mushroom == "brown")
	button_blue.disabled = (MushroomManager.selected_mushroom == "blue")
