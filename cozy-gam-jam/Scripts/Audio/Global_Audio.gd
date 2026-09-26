extends Node

@onready var audioplayer: AudioStreamPlayer = $MusicStreamPlayer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_check_button_toggled(toggled_on: bool) -> void:
	var Music_bus = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_mute(Music_bus, not toggled_on)
	#audioplayer.stream_paused = true

func _on_sfxmutebutton_toggled(toggled_on: bool) -> void:
	var SFX_bus = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_mute(SFX_bus, not toggled_on)
