extends Node2D

@export var shop_content_scene: PackedScene = preload("res://scenes/Shop/ShopContent/ShopContent.tscn")
@export var ui_manager_scene: PackedScene = preload("res://scenes/UI_Manager/UIManager.tscn")
@onready var interaction_area: Area2D = $InteractionArea
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var shop_content: Control = null
var scene_of_Shop: String = "res://scenes/Shop/ShopContent/ShopContent.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	interaction_area.interact = Callable(self, "open_shop")


func open_shop():
	show_shop_ui()


func show_shop_ui():
	$'../../../Pause_Menu/UiManager/ShopContent'.show()
	
func _on_ui_closed():
	print("Shop UI was closed.")
	shop_content.queue_free()

func _process(delta):
	animation_player.play("idle")
