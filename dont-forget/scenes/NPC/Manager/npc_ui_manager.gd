extends Control

@export var ui_element_template: PackedScene # UI template (e.g., shop, quest, etc.)
@onready var ui_container: Control = $UI_Container

var current_npc = null

func update_ui(npc: Node):
	current_npc = npc

	# Clear the current UI
	clear_ui()

	if npc.has_method("get_shop_items"):
		print("NPC has shop items.")
		var shop_items = npc.get_shop_items()
		for item in shop_items:
			var ui_element = ui_element_template.instantiate()
			ui_container.add_child(ui_element)
			ui_element.set_item(item)

	# Clears the current UI elements
func clear_ui():
	for child in ui_container.get_children():
		child.queue_free()
