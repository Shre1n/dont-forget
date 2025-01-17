extends Node2D


@onready var owl_audio = $AudioStreamPlayer2D

@onready var anim = $AnimatedSprite2D
@export var max_distance_audio: float 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anim.play("idle")
	owl_audio.max_distance = max_distance_audio
	owl_audio.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	owl_audio.play()


func _on_area_2d_body_exited(body: Node2D) -> void:
	owl_audio.stop()
