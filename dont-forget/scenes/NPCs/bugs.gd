extends Node2D

@onready var bugs_audio = $Audio_Stream

@onready var animation = $AnimatedSprite2D
@export var max_distance_audio: float 
@export var flip_h: bool = false
@export var audio_on: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if flip_h:
		animation.flip_h = true
	animation.play("idle")
	bugs_audio.max_distance = max_distance_audio
	if max_distance_audio == 0:
		bugs_audio.max_distance = 0
	bugs_audio.kaefer_audio()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
