extends Node2D


@onready var interaction_area = $InteractionArea

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interaction_area.interact = Callable(self, "on_talk")


func on_talk():
	pass
