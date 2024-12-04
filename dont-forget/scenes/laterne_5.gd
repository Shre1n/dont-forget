extends Sprite2D


@onready var light = $PointLight2D

# Called when the node enters the scene tree for the first time.
func _ready():
	flicker_light()

func flicker_light():
	light.energy = randf_range(0.8,3)
	await(get_tree().create_timer(0.5).timeout)
	flicker_light()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
