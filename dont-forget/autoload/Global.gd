extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


var new_position
var new_direction

var coins: int
var price_multi: float = 1

var cutscene: bool = false
var lastCutsceneNr: int = 0
#var talkpos: Vector2 = Vector2(0,0)
