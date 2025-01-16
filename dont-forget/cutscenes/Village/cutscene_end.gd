extends Node2D

@export var anim_player: AnimationPlayer
@export var camera_player: AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anim_player.play("anim")
	camera_player.play("zoom")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
