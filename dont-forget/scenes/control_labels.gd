extends Node2D

@onready var move = $Move
@onready var jump = $Jump
@onready var attack = $Attack
@onready var stats_popup = $Stats_popup


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_keys()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_keys()

func update_keys():
	if Input.get_connected_joypads().size() > 0:
		move.text = "LEFT Stick to move"
		jump.text = "A to jump"
		attack.text = "X to attack"
		stats_popup.text = "L1 to discover or hide your stats"
	else:
		move.text = "Press A or D to move"
		jump.text = "Press W to jump"
		attack.text = "Press LEFT MOUSE to attack"
		stats_popup.text = "Press I to discover or hide your stats"
