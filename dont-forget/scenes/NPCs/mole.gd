extends Node2D

@onready var mole_audio = $idle

@onready var anim = $AnimationPlayer
@export var max_distance_audio: float
@export var visibility_enabler: VisibleOnScreenEnabler2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mole_audio.max_distance = max_distance_audio


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_visible_on_screen_enabler_2d_screen_entered() -> void:
	anim.play("idle")


func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	anim.stop()
