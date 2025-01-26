extends Node2D

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var world_Env: WorldEnvironment = $WorldEnvironment
@onready var sword = $Sword
@onready var character = $"../Character"
@onready var block = $"../Block/Block"
@onready var audio_on_sword_pickup = $on_pickup


@export var visible_load: VisibleOnScreenNotifier2D

@onready var attack_label = $"../Control Labels/Attack"
@onready var pickup_label = $"../PickUp"

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


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	self.visible = true


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	self.visible = false
