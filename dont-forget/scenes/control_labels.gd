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
	if not initialized:
		update_keys()
		initialized = true

func get_action_text(action_name: String) -> String:
	var events = InputMap.action_get_events(action_name)
	result.clear()
	if events.size() > 0 :
		var event = events[0]
		if event is InputEventJoypadButton:
			result.append(event.as_text())
		if event is InputEventKey:
			result.append(event.as_text())
	return ", ".join(result)
	



func update_keys():
	move.text = "%s to move" % get_action_text("left")
	jump.text = "%s to jump" % get_action_text("jump")
	attack.text = "%s to attack" % get_action_text("attack")
	stats_popup.text = "%s to discover or hide your stats" % get_action_text("inventory")
