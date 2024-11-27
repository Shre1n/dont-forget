extends Control

@export var ui_element_template: PackedScene # UI template (e.g., shop, quest, etc.)
@onready var ui_container: Control = $UI_Container/GridContainer

var current_npc = null

func update_ui(npc: Node):
	current_npc = npc

	# Clear the current UI
	clear_ui()

	if npc.has_method("get_shop_items"):
		var shop_items = npc.get_shop_items()
		for item in shop_items:
			var ui_element = ui_element_template.instantiate()
			if ui_element:
				ui_container.add_child(ui_element)
				ui_element.set_item(item)
				print("Item: ", item)
				print("UI Element: ", ui_element)
			else:
				print("Error: ui_element is not of type ShopItem")
				print(ui_container.get_child(0), typeof(ui_container))
				print(ui_container.get_child(1), typeof(ui_container))

	# Clears the current UI elements
func clear_ui():
	for child in ui_container.get_children():
		child.queue_free()
