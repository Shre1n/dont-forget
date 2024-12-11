extends Node2D

@export var shop_content_scene: PackedScene = preload("res://scenes/Shop/ShopContent/ShopContent.tscn")
@export var ui_manager_scene: PackedScene = preload("res://scenes/UI_Manager/UIManager.tscn")
@onready var interaction_area: Area2D = $InteractionArea
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var ui_manager: Control = null

# Called when the node enters the scene tree for the first time.
func _ready():
	interaction_area.interact = Callable(self, "open_shop")


func open_shop():
	show_shop_ui()


func show_shop_ui():
	ui_manager = ui_manager_scene.instantiate()
	get_tree().root.add_child(ui_manager)
	
	var scene: String = "res://scenes/Shop/ShopContent/ShopContent.tscn"
	
	ui_manager.load_content(scene)
	ui_manager.connect("ui_closed", Callable(self, "_on_ui_closed"))
	
func _on_ui_closed():
	print("Shop UI was closed.")
	ui_manager = null

func _process(delta):
	animation_player.play("idle")
