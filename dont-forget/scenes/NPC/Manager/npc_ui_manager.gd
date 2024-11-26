extends Control

@export var ui_element_template: PackedScene # UI template (e.g., shop, quest, etc.)
@onready var ui_container: Control = $UI_Container

var current_npc = null

func update_ui(npc: Node):
	current_npc = npc

	# Clear the current UI
	clear_ui()

	if npc.has_method("get_shop_items"):
		var shop_items = npc.get_shop_items()
		for item in shop_items:
			var ui_element = ui_element_template.instantiate()
			ui_element.update_element(item["name"], item["description"], item["icon_texture"], item["action_data"])
			ui_container.add_child(ui_element)
		
	elif npc.has_method("get_quest_data"):
		var quest_data = npc.get_quest_data()
		var ui_element = ui_element_template.instantiate()
		ui_element.set_quest(quest_data)
		ui_container.add_child(ui_element)
		
	else:
		var dialog_ui = ui_element_template.instantiate()
		dialog_ui.set_text(npc.get_dialog())
		ui_container.add_child(dialog_ui)

	# Clears the current UI elements
func clear_ui():
	for child in ui_container.get_children():
		child.queue_free()
