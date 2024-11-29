extends Node2D


@onready var houseAnim = $"Environment/Homes/Home 1"
@onready var houseAnim2 = $"Environment/Homes/Home 2"


# Called when the node enters the scene tree for the first time.
func _ready():
	houseAnim.play("default")
	houseAnim2.play("default")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
