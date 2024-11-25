extends Node2D

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var world_Env: WorldEnvironment = $WorldEnvironment
@onready var sword = $Sword
@onready var character = $"../Character"

func _ready():
	interaction_area.interact = Callable(self, "on_pick_up")
	
func on_pick_up():
	character.sword = true
	sword.queue_free()
	world_Env.queue_free()
	interaction_area.queue_free()
