extends AnimatedSprite2D
@onready var light = $PointLight2D

func _ready():
	flicker_light()

func flicker_light():
	light.energy = randf_range(1.2,3)
	await(get_tree().create_timer(5.0).timeout)
	flicker_light()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
