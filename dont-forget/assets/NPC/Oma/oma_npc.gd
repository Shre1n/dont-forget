extends Node2D


@onready var interaction_area = $InteractionArea
@onready var animation_player = $AnimationPlayer
@export var dialog_resource: DialogueResource

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interaction_area.interact = Callable(self, "on_talk")
	animation_player.play("idle")


func on_talk():
	animation_player.play("talk")
	DialogueManager.show_example_dialogue_balloon(dialog_resource, "start")
