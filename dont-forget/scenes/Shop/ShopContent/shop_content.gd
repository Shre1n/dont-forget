extends Control

signal item_purchase(price)

@export var player : Character

@onready var game_manager = find_game_manager()

var current_player: Character

# Shop items as a dictionary for key-based identification
var shop_items: Dictionary = {
	"damage": { "name": "damage", "price": 100 },
	"health": { "name": "health", "price": 150 },
	"speed": { "name": "speed", "price": 50 }
}

@onready var vbox_container: VBoxContainer = $VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	game_manager.connect("current_user", Callable(self, "self_user"))
	populate_shop()
	

func self_user(path):
	current_player = path

func populate_shop():
	for key in shop_items.keys():
		var item = shop_items[key]
		print(key)
		
		var margin_container = MarginContainer.new()
		margin_container.add_theme_constant_override("margin_top", 10)
		margin_container.add_theme_constant_override("margin_left", 20)
		margin_container.add_theme_constant_override("margin_bottom", 10)
		margin_container.add_theme_constant_override("margin_right", 20)
		vbox_container.add_child(margin_container)

		var hcontainer = HBoxContainer.new()
		hcontainer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		vbox_container.add_child(hcontainer)

		var name_label: Label = Label.new()
		name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		name_label.text = item["name"]  # Access item name
		hcontainer.add_child(name_label)

		var price_label: Label = Label.new()
		price_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		price_label.text = str(item["price"]) + " Gold"  # Access item price
		hcontainer.add_child(price_label)

		var buy_button: Button = Button.new()
		buy_button.text = "Buy"
		buy_button.connect("pressed", Callable(self, "_on_buy_button_pressed").bind(key))  # Pass the item's key
		buy_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		hcontainer.add_child(buy_button)

		vbox_container.add_child(HSeparator.new())

func _on_buy_button_pressed(key):
	# Access the item using its key
	var item = shop_items[key]
	print(current_player.coins, -item["price"])
	current_player.connect("coinChange",-item["price"])
	emit_signal("item_purchase", item["price"])
	print("Purchased: ", item["name"])
	
func find_game_manager():
	var root = get_tree().root  # Root-Node des Scene Trees
	for child in root.get_children():
		if child.name == "Game_Manager":
			return child
	return null
