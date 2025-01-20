extends Node2D

@onready var light = $Home/PointLight2D
@onready var sprite = $Home
@export var flip_h: bool

func _ready():
	if	flip_h:
		self.flip_h = true

func flicker_light():
	light.energy = randf_range(1.2,3)
	await(get_tree().create_timer(5.0).timeout)
	flicker_light()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_visible_on_screen_enabler_2d_screen_entered() -> void:
	sprite.play("default")
	flicker_light()


func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	sprite.stop()
