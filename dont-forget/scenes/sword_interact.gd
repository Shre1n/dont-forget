extends Node2D

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var world_Env: WorldEnvironment = $WorldEnvironment
@onready var sword = $Sword


func _ready():
	interaction_area.interact = Callable(self, "on_pick_up")
	
func on_pick_up():
	print("Picked up the sword!")
	sword.queue_free()
	world_Env.queue_free()
	interaction_area.queue_free()
