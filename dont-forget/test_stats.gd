extends Area2D

@export var value1 = -50
@export var value2 = -50
@export var value3 = -50
@onready var stat_changes = [
	{"stat": "damage_stat", "amount": value1},
	{"stat": "speed_stat", "amount": value2},
	{"stat": "jump_stat", "amount": value3}
]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body.name == "Character":
		body.adjust_stats(stat_changes)
