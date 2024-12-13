extends Control

signal item_purchase(price)

#@export var player : Character

@onready var game_manager = find_game_manager()
@export var price_adder = 1

var current_player: Character

# Shop items as a dictionary for key-based identification
var shop_items: Dictionary = {
	"damage_stat": { "name": "Damage", "price": 1, "stat": "damage_stat" },
	"speed_stat": { "name": "Speed", "price": 2, "stat": "speed_stat" },
	"jump_stat": { "name": "Jump Hight", "price": 3, "stat": "jump_stat"}
}

@onready var vbox_container: VBoxContainer = $VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	game_manager.connect("current_user", Callable(self, "self_user"))	

func self_user(path):
	current_player = path
	populate_shop()
	current_player.open = true
	current_player.stats_popup.visible = true

func populate_shop():
	for key in shop_items.keys():
		var item = shop_items[key]
		#print(key)
		var new_item_price = round(item["price"]* Global.price_multi)
		
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
		price_label.text = str(new_item_price) + " Gold"  # Access item price
		hcontainer.add_child(price_label)

		var buy_button: Button = Button.new()
		if current_player.coins < new_item_price:
			buy_button.text = "Too poor"
			buy_button.disabled = true
		else:
			buy_button.text = "Buy"
			buy_button.connect("pressed", Callable(self, "_on_buy_button_pressed").bind(key))  # Pass the item's key
		buy_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		hcontainer.add_child(buy_button)

		vbox_container.add_child(HSeparator.new())

func _on_buy_button_pressed(key):
	# Access the item using its key
	var item = shop_items[key]
	#print(current_player.coins, -item["price"])
	current_player.get_coins(-item["price"])
	emit_signal("item_purchase", item["price"])
	#print("Purchased: ", item["name"])
	var test = cal_new_value()
	var changes = [{"stat": item["stat"], "amount": test}]
	#var changes = [{"stat": item["name"]+"_stat", "amount": cal_new_value()}]
	current_player.adjust_stats(changes)
	Global.price_multi += price_adder
	for child in $VBoxContainer.get_children():
		child.queue_free()
	populate_shop()

@export var weights = [5, 10, 20, 30, 40, 30, 20, 10, 5, 2] # Gewichtungen
@export var min_values = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10] # Minimalwerte
@export var max_values = [3, 5, 8, 12, 15, 18, 22, 25, 30, 35] # Maximalwerte
@export var is_enabled = [true, true, true, true, true, true, true, true, true, true] # Aktivierungsstatus

func cal_new_value():
	var total_weight = 0
	var cumulative_weights = []
	
	# Berechne kumulative Gewichtung (inkl. Deaktivierung)
	for i in range(weights.size()):
		if is_enabled[i]:
			total_weight += weights[i]
		cumulative_weights.append(total_weight)
		
	# Zufallswert innerhalb des Bereichs
	var random_value = randi() % total_weight
	
	# Verhalten finden
	var selected_index = -1
	for i in range(cumulative_weights.size()):
		if random_value < cumulative_weights[i]:
			selected_index = i
			break
	
	if selected_index == -1:
	# Fallback, falls kein Index gefunden wurde
		print("Kein Verhalten ausgewählt. Überprüfen Sie die Gewichtungseinstellungen.")
		return
	
	# Werte abrufen
	var min_value = min_values[selected_index]
	var max_value = max_values[selected_index]
	
	# Zufällige Menge innerhalb des Bereichs generieren
	var menge = round(randf_range(min_value, max_value))
	return menge

func find_game_manager():
	var root = get_tree().root  # Root-Node des Scene Trees
	for child in root.get_children():
		if child.name == "Game_Manager":
			return child
	return null


signal closing

func close_npc():
	emit_signal("closing")
	current_player.open = false
	current_player.stats_popup.visible = false
