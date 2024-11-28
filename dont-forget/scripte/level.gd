class_name Level extends Node2D

@onready var boss_manager: Node2D = $Manager


# Called when the node enters the scene tree for the first time.
func _ready():
	boss_manager.spawn_boss("Drexus", Vector2(1000,6000))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
