extends Node2D

@onready var mole_audio = $Audio_Stream

@onready var anim = $AnimatedSprite2D
@export var max_distance_audio: float 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anim.play("idle")
	mole_audio.max_distance = max_distance_audio
	mole_audio.maulwurf_audio()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
