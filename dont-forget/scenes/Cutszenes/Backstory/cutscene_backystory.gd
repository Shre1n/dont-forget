extends Node2D

@onready var ani_player = $Bilder/AnimationPlayer
@export var dialog : DialogueResource
@onready var dialog_ := $DialogueLabel
var _position = Vector2(100,100)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ani_player.play("backstory")
	DialogueManager.show_example_dialogue_balloon(dialog,"start_BS")
	

func simulate_button_pressed():
	var event = InputEventMouseButton.new()
	event.position = _position
	event.button_index = MOUSE_BUTTON_LEFT
	event.pressed = true
	Input.parse_input_event(event)

	# Zum Loslassen des Klicks sofort ein zweites Event senden
	var release_event = InputEventMouseButton.new()
	release_event.position = _position
	release_event.button_index = MOUSE_BUTTON_LEFT
	release_event.pressed = false
	Input.parse_input_event(release_event)


func _on_animated_sprite_2d_frame_changed() -> void:
	simulate_button_pressed()
