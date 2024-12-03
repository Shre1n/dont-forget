extends Node2D


@onready var houseAnim = $"Environment/Homes/Home 1"
@onready var houseAnim2 = $"Environment/Homes/Home 2"
@onready var houseAnim3 = $"Environment/Homes/Home 3"
@onready var houseAnim4 = $"Environment/Homes/Home 4"


# Called when the node enters the scene tree for the first time.
func _ready():
	houseAnim.play("default")
	houseAnim2.play("default")
	houseAnim3.play("default")
	houseAnim4.play("default")
	
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
