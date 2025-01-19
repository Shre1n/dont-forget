extends Node2D

@onready var ani_player = $Bilder/AnimationPlayer
@export var dialog : DialogueResource

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ani_player.play("backstory")
	DialogueManager.show_example_dialogue_balloon(dialog,"start_BS")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
