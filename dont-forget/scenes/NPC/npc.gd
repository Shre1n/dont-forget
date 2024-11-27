extends Node2D

@onready var interaction_area: Area2D = $InteractionArea
@onready var npc_ui_manager: Node = $NPC_UI

@export var shop_items: Array = [
		{"name": "Sword", "price": 100, "description": "A sharp sword.", "icon_texture": null, "action_data": {}},
		{"name": "Shield", "price": 50, "description": "A sturdy shield.", "icon_texture": null, "action_data": {}}
	]
signal interact_with_player(npc)

func _ready():
	interaction_area.interact = Callable(self, "on_interact")


func on_interact():
	# Pass this NPC instance to the UI Manager
	npc_ui_manager.update_ui(self)
	get_tree().paused = true

func get_shop_items() -> Array:
	return shop_items
