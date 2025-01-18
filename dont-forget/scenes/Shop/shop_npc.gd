extends Node2D

@export var shop_content_scene: PackedScene = preload("res://scenes/Shop/ShopContent/ShopContent.tscn")
@export var ui_manager_scene: PackedScene = preload("res://scenes/UI_Manager/UIManager.tscn")
@export_enum("default", "second_shop") var selected_profile: String = "default"
@onready var interaction_area: Area2D = $InteractionArea
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var ui_manager = $'../../../Pause_Menu/UiManager'
@onready var ui_manager_container = $'../../../Pause_Menu/UiManager/Panel/Container'
@onready var anim_moni = $monitoable_anim
var shop_content: Control = null
var scene_of_Shop: String = "res://scenes/Shop/ShopContent/ShopContent.tscn"

@onready var pete_audio = $Audio_Stream

@onready var game_manager = find_game_manager()
var current_player: Character

var is_shop_open : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	interaction_area.interact = Callable(self, "open_shop")
	game_manager.connect("current_user", Callable(self, "self_user"))
	pete_audio.lucky_pete_frog_audio()

func close_areabackup():
	if $Leave.monitoring == true:
		anim_moni.play("hide_it")
		#print($Leave.monitoring,"4")
	#print($Leave.monitoring,"1")

func open_shopbackup():
	show_shop_ui()
	#print($Leave.monitoring,"2")
	anim_moni.play("show_it")
	#print($Leave.monitoring,"3")


func open_shop():
	if is_shop_open:
		return  # Verhindert das Öffnen des Shops, wenn er bereits geöffnet ist
	pete_audio.stop()
	pete_audio.lucky_pete_money_audio()
	is_shop_open = true  # Markiert den Shop als geöffnet
	show_shop_ui()  # Zeigt das Shop UI
	#print($Leave.monitoring, "2")
	anim_moni.play("show_it")
	#print($Leave.monitoring, "3")

func show_shop_ui():
	ui_manager.load_content(scene_of_Shop, selected_profile)
	ui_manager_container.get_child(0).connect("closing", Callable(self, "close_area"))
	
#func _on_ui_closed():
	#print("Shop UI was closed.")
	#shop_content.queue_free()
	#ui_manager.close()

func close_area():
	if $Leave.monitoring == true:
		anim_moni.play("hide_it")
		pete_audio.popUp_audio()
		#print($Leave.monitoring, "4")
	#print($Leave.monitoring, "1")
	is_shop_open = false 

func _process(delta):
	animation_player.play("idle")


func _on_leave_body_exited(body):
	if body.name == "Character":
		ui_manager.close()
		close_area()
		current_player.open = false
		current_player.stats_popup.visible = false

func self_user(path):
	current_player = path

func find_game_manager():
	var root = get_tree().root  # Root-Node des Scene Trees
	for child in root.get_children():
		if child.name == "Game_Manager":
			return child
	return null
