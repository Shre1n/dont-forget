extends Control

@onready var closed_button: Button = $Panel/CloseButton
@onready var content_holder: Container = $Panel/Container
@onready var shop_content: Control = $ShopContent

@onready var game_manager = find_game_manager()
var current_char

func _ready():
	closed_button.connect("pressed", Callable(self, "_on_close_button_pressed"))
	game_manager.connect("current_user", Callable(self, "set_char"))
	shop_content.connect("item_purchase", Callable(self, "decrease_coins"))
	

func decrease_coins(value):
	current_char.connect("coinsChange", -value)


func set_char(path):
	current_char = path

func load_content(scene_path: String):
	var scene = load(scene_path).instantiate()
	content_holder.add_child(scene)
	
	self.show()

func _on_close_button_pressed(): 
	self.hide()
	for child in content_holder.get_children():
		child.queue_free()
		
		

func find_game_manager():
	var root = get_tree().root  # Root-Node des Scene Trees
	for child in root.get_children():
		if child.name == "Game_Manager":
			return child
	return null
