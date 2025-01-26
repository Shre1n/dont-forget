extends Node2D

@onready var ui_manager_container = $'../../../Pause_Menu/UiManager/Panel/Container'
@onready var ui_manager = $'../../../Pause_Menu/UiManager'
@onready var interaction_area: Area2D = $InteractionArea
var scene_of_Hint: String = "res://scenes/wegweiser/hint_content.tscn"

@export var hintText : String = ""

@onready var audio = $PopUp_close

func _init() -> void:
	print("Schild")

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
	audio.play()
	var child = ui_manager_container.get_child(0)
	print(child)
	child.queue_free()
 
func open_hint():
	ui_manager.load_content(scene_of_Hint)
	var text = ui_manager.get_child(0).get_child(0).get_child(0).get_child(0).get_child(0)
	text.text = hintText
	ui_manager_container.get_child(0).connect("closing", Callable(self, "close_area"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
