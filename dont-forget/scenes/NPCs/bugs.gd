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
	bugs_audio.max_distance = max_distance_audio


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_visible_on_screen_enabler_2d_screen_entered() -> void:
	anim_player.play("idle")


func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	anim_player.stop()
