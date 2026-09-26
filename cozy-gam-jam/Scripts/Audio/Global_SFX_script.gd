extends Node

@onready var mushplace = $Stream_MushPlacement
@onready var buttonClick = $Stream_ButtonClick

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func playMushplacement():
	mushplace.play()
	await mushplace.finished

func playClick():
	buttonClick.play()
	await buttonClick.finished
