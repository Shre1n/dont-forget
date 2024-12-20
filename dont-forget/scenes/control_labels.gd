extends Node2D

@onready var move = $Move
@onready var jump = $Jump
@onready var attack = $Attack
@onready var stats_popup = $Stats_popup

var input_mappings = ["right", "left", "attack", "inventar"]

var result = []

var initialized = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_keys()
	
func _process(delta: float) -> void:
	update_keys()

func get_action_text(action_name: String) -> String:
	var events = InputMap.action_get_events(action_name)
	result.clear()
	for event in events:
		if event is InputEventJoypadMotion:
			var full_text = event.as_text()
			if "Left Stick" in full_text:
				result.append("LEFT Stick")
			#if "Xbox X" in full_text:
				#result.append("X")
	
	return "".join(result)
	



func update_keys():
	if !initialized:
		get_action_text("left")
		#get_action_text("attack")
		initialized = true
	print(result)
	if Input.get_connected_joypads().size() > 0:
		move.text = result[0] + " to move"
		jump.text = "A to jump"
		attack.text = result[1] + " to attack"
		stats_popup.text = "L1 to discover or hide your stats"
	else:
		move.text = "Press A or D to move"
		jump.text = "Press W to jump"
		attack.text = "Press LEFT MOUSE to attack"
		stats_popup.text = "Press I to discover or hide your stats"
