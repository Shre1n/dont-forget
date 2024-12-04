extends Node2D


@onready var housePNG: AnimatedSprite2D = $AnimatedSprite2D
@

# Called when the node enters the scene tree for the first time.
func _ready():
	housePNG.play("HouseFunnel");


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
