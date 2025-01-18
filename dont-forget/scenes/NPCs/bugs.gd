extends Node2D

@onready var bugs_audio = $idle

@onready var animation = $AnimatedSprite2D
@onready var anim_player = $AnimationPlayer
@export var max_distance_audio: float 
@export var flip_h: bool = false
@export var audio_on: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if flip_h:
		animation.flip_h = true
	anim_player.play("idle")
	bugs_audio.max_distance = max_distance_audio


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
