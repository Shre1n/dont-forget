extends Node2D

@onready var animation =$Mole
@onready var animation1 =$Mole2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation.play("idle")
	animation1.play("idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
