extends Control


# Properties
@export var element_name: String = "Element Name"
@export var description: String = "Description here..."
@export var icon_texture: Texture2D
@export var action_data: Dictionary = {}  # Data passed when the action is triggered.

@onready var name_label = $Name
@onready var description_label = $Description
@onready var action_button = $Button
@onready var icon = $Icon


func _ready():
	name_label.text = element_name
	description_label.text = description
	if	icon_texture:
		icon_texture = icon_texture
	else:
		icon.hide()
	action_button.text = "Select"
	action_button.connect("pressed", Callable(self, "action_triggered"))
	
func _on_action_pressed():
	emit_signal("action_triggered", action_data)
	
func update_element(name: String, desc: String, texture: Texture2D, action: Dictionary):
	element_name = name
	description = desc
	icon_texture = texture
	action_data = action
	
	name_label.text = name
	description_label.text = desc
	if texture:
		icon_texture = texture
		icon.show()
	else:
		icon.hide()
	
	
	
	
	
	
	
	
