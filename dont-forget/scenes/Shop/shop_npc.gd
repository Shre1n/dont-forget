extends Node2D


@export var shop_ui_scene: PackedScene
@onready var interaction_area: Area2D = $InteractionArea
var ui_manager = null

# Called when the node enters the scene tree for the first time.
func _ready():
	interaction_area.interact = Callable(self, "open_shop")


func open_shop():
	show_shop_ui()


func show_shop_ui():
	if ui_manager:
		return
	
	ui_manager = preload("res://scenes/UI_Manager/UIManager.tscn").instantiate()
	get_tree().root.add_child(ui_manager)
	
	if shop_ui_scene:
		ui_manager.connect("ui_closed", Callable(self, "_on_ui_closed"))
	
func _on_ui_closed():
	ui_manager = null
		
