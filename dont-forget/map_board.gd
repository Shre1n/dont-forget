extends Node2D

@onready var ui_manager_container = $'../../../Pause_Menu/UiManager/Panel/Container'
@onready var ui_manager = $'../../../Pause_Menu/UiManager'
@onready var interaction_area: Area2D = $InteractionArea
var map_image: String = "res://scenes/Map_Board/image.tscn"

@export var map_image_pointer : Vector2
# Called when the node enters the scene tree for the first time.
func _ready():
	interaction_area.interact = Callable(self, "toggle_hint")


func toggle_hint():
	if ui_manager.visible:
		close_hint()
	else:
		open_hint()

# Function to close the hint UI
func close_hint():
	ui_manager_container.get_child(0).disconnect("closing", Callable(self, "close_area"))
	ui_manager.hide()  # Hide the UIManager
	var child = ui_manager_container.get_child(0)
	child.queue_free()
 
func open_hint():
	ui_manager.load_content(map_image)
	ui_manager_container.get_child(0).get_child(1).position = map_image_pointer
	ui_manager_container.get_child(0).connect("closing", Callable(self, "close_area"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
