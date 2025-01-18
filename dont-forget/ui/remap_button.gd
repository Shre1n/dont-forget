extends Button
class_name RemapButton

@export var action: String

@onready var audio_player: Audio_Stream = Audio_Stream.new()

@export var button_sound: AudioStream

func _init() -> void:
	toggle_mode = true
	theme_type_variation = "RemapButton"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_child(audio_player)
	audio_player.stream = button_sound
	set_process_unhandled_input(false)
	update_key_text()

func _toggled(toggled_on: bool) -> void:
	set_process_unhandled_input(toggled_on)
	if toggled_on:
		play_button_sound()
		text = "... Awaiting Input ..."
		release_focus()
	else:
		update_key_text()
		grab_focus()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_pressed():
		InputMap.action_erase_events(action)
		InputMap.action_add_event(action, event)
		button_pressed = false


func update_key_text():
	text = "%s" % InputMap.action_get_events(action)[0].as_text()
	
func play_button_sound() -> void:
	if button_sound:
		audio_player.play()
