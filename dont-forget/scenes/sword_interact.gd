extends Node2D

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var world_Env: WorldEnvironment = $WorldEnvironment
@onready var sword = $Sword
@onready var character = $"../Character"
@onready var block = $"../Block/Block"
@onready var attack_label = $"../Labels/Attack"
@onready var pickup_label = $"../Labels/PickUp"
@onready var audio_on_sword_pickup = $on_pickup

func _ready():
	interaction_area.interact = Callable(self, "on_pick_up")
	
func on_pick_up():
	audio_on_sword_pickup.play()
	character.sword = true
	attack_label.show()
	pickup_label.hide()
	block.queue_free()
	sword.queue_free()
	world_Env.queue_free()
	interaction_area.queue_free()
