extends Node2D

@onready var interaction_area: InteractionArea = $InteractionArea

signal boss_defeated(boss_name: String)
signal boss_engaged(boss_name: String)

@export var max_health: int = 100
var current_heath: int = max_health

func _ready(damage: int = 10):
	interaction_area.interact = Callable(self, "on_hit")

func on_hit(damage: int = 10):
	current_heath -= damage
	print("Boss hit! Remain! HP: ", current_heath)
	emit_signal
	
	if current_heath <= 0:
		die()

func die():
	emit_signal("boss_defeated")
	queue_free()
