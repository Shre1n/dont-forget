extends Node2D

@onready var interaction_area: Area2D = $InteractionArea
@onready var npc_ui_manager: Node = $NPC_UI

@export var shop_items: Array = [
		{"name": "Sword", "price": 100, "description": "A sharp sword.", "icon_texture": null, "action_data": {}},
		{"name": "Shield", "price": 50, "description": "A sturdy shield.", "icon_texture": null, "action_data": {}}
	]
signal interact_with_player(npc)

func _ready():
	interaction_area.connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.is_in_group("Character"):
		# Notify the NPC_UIManager to update the UI based on this NPC
		npc_ui_manager.update_ui(self)
		emit_signal("interact_with_player", self)
		
		
func get_shop_items() -> Array:
	return shop_items
