extends Node2D

@onready var move_buttons: Label = $Move
@onready var jump_button: Label = $Jump
@onready var attack_button: Label = $Attack
@onready var stats_button: Label = $Stats_popup

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_action_texts()


func get_action_bindings(action_name: String) -> String:
	var events = InputMap.action_get_events(action_name)
	var bindings = []
	for event in events:
		if event is InputEventKey:
			bindings.append(OS.get_keycode_string(event.keycode))
		elif event is InputEventMouseButton:
			bindings.append("Mouse Button %d" % event.button_index)
		elif event is InputEventJoypadButton:
			bindings.append("Joypad Button %d" % event.button_index)
		elif event is InputEventJoypadMotion:
			bindings.append("Joystick Axis %d" % event.axis)
	return " or ".join(bindings) if bindings.size() > 0 else "Unbound"
	
func update_action_texts():
	var left_bindings = get_action_bindings("left")
	var right_bindings = get_action_bindings("right")
	var jump_bindings = get_action_bindings("jump")
	var attack_bindings = get_action_bindings("attack")
	var stats_bindings = get_action_bindings("inventar")
	
	var is_gamepad_connected = Input.get_connected_joypads().size() > 0
	
	if is_gamepad_connected:
		move_buttons.text = "Use LEFT STICK to move"
		jump_button.text = "Press A to jump"
		attack_button.text = "Press X to attack"
		stats_button.text = "Press Y to show stats"
	else:
		move_buttons.text = "Press %s " % left_bindings + "%s " % right_bindings + "to move" 
		jump_button.text = "Press %s to jump" % jump_bindings
		attack_button.text = "Press %s to attack" % attack_bindings
		stats_button.text = "Press %s to show stats" % stats_bindings
