extends HBoxContainer

@onready var button_mothermush: Button = $button1_mothershroom
@onready var button_lilmush: Button = $button2_lilshroom
@onready var button_appliance: Button = $button3_myceliumblock

func _ready() -> void:
	button_mothermush.pressed.connect(_on_mushroom_selected.bind("brown"))
	button_lilmush.pressed.connect(_on_mushroom_selected.bind("blue"))
	_update_button_highlight()

func _on_mushroom_selected(type: String) -> void:
	MushroomManager.set_selected_mushroom(type)
	_update_button_highlight()

func _update_button_highlight() -> void:
	button_mothermush.disabled = (MushroomManager.selected_mushroom == "brown")
	button_lilmush.disabled = (MushroomManager.selected_mushroom == "blue")
