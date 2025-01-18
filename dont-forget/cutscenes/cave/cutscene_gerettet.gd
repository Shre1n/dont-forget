extends Node2D

@export var ani_player : AnimationPlayer
@export var camera_player: AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ani_player.play("happy")
	camera_player.play("zoom")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
