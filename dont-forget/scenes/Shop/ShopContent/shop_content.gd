extends Control

signal item_purchase(price)

#@export var player : Character
@export var font_path : String = "res://addons/gut/fonts/CourierPrime-Bold.ttf"

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
	var theme = Theme.new()
	apply_button_style(theme)  # Buttons stylen
	vbox_container.theme = theme  # Theme dem Container zuweisen

func self_user(path):
	current_player = path
	populate_shop()
	current_player.open = true
	current_player.stats_popup.visible = true

func apply_button_style(theme: Theme):
	var button_style = StyleBoxFlat.new()
	button_style.bg_color = Color("4e357e")  # Button-Hintergrundfarbe
	button_style.border_color = Color(1, 1, 1)  # Weißer Rand
	button_style.border_width_top = 5
	button_style.border_width_bottom = 5
	button_style.border_width_left = 5
	button_style.border_width_right = 5
	button_style.corner_radius_top_left = 5
	button_style.corner_radius_top_right = 5
	button_style.corner_radius_bottom_left = 5
	button_style.corner_radius_bottom_right = 5
	
	theme.set_stylebox("normal", "Button", button_style)
	theme.set_stylebox("hover", "Button", button_style)  # Optional: Hover
	theme.set_stylebox("pressed", "Button", button_style)

func populate_shop1():
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
		
func populate_shop2():
	for key in shop_items.keys():
		var item = shop_items[key]
		var new_item_price = round(item["price"] * Global.price_multi)

		# MarginContainer für Abstand und Styling
		var margin_container = MarginContainer.new()
		margin_container.add_theme_constant_override("margin_top", 10)
		margin_container.add_theme_constant_override("margin_left", 20)
		margin_container.add_theme_constant_override("margin_bottom", 10)
		margin_container.add_theme_constant_override("margin_right", 20)
		vbox_container.add_child(margin_container)

		# HBoxContainer für horizontales Layout
		var hcontainer = HBoxContainer.new()
		hcontainer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		margin_container.add_child(hcontainer)

		# TextureRect für Icon
		var icon_texture = TextureRect.new()
		icon_texture.texture = preload("res://icon_stats/Damage.png")  # Pfad zum Icon
		icon_texture.expand = true
		icon_texture.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		hcontainer.add_child(icon_texture)

		# Label für Item-Name
		var name_label: Label = Label.new()
		name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		name_label.text = item["name"]  # Access item name
		name_label.add_theme_font_override("font", preload("res://addons/gut/fonts/CourierPrime-Bold.ttf"))
		name_label.add_theme_color_override("font_color", Color(1, 1, 1))  # Weißer Text
		name_label.add_theme_constant_override("margin_left", 10)  # Abstand links
		hcontainer.add_child(name_label)

		# Label für Preis
		var price_label: Label = Label.new()
		price_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		price_label.text = str(new_item_price) + " Gold"  # Access item price
		price_label.add_theme_font_override("font", preload("res://addons/gut/fonts/CourierPrime-Bold.ttf"))
		price_label.add_theme_color_override("font_color", Color(1, 0.84, 0))  # Goldener Text
		price_label.add_theme_constant_override("margin_right", 10)  # Abstand rechts
		hcontainer.add_child(price_label)

		# Button für Kauf
		var buy_button: Button = Button.new()
		if current_player.coins < new_item_price:
			buy_button.text = "Too poor"
			buy_button.disabled = true
			buy_button.add_theme_color_override("font_color", Color(0.5, 0.5, 0.5))  # Grauer Text
			buy_button.add_theme_color_override("disabled_bg_color", Color(0.2, 0.2, 0.2))  # Grauer Hintergrund
		else:
			buy_button.text = "Buy"
			buy_button.connect("pressed", Callable(self, "_on_buy_button_pressed").bind(key))  # Pass the item's key
			buy_button.add_theme_color_override("font_color", Color(1, 1, 1))  # Weißer Text
			buy_button.add_theme_color_override("bg_color", Color(100, 0.6, 0.2))  # Grüner Hintergrund
		buy_button.add_theme_font_override("font", preload("res://addons/gut/fonts/CourierPrime-Bold.ttf"))
		buy_button.add_theme_constant_override("margin_left", 10)
		buy_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		hcontainer.add_child(buy_button)

		# Horizontale Linie
		vbox_container.add_child(HSeparator.new())
		
func populate_shop3():
	for key in shop_items.keys():
		var item = shop_items[key]
		var new_item_price = round(item["price"] * Global.price_multi)

		# MarginContainer für Abstand und Styling
		var margin_container = MarginContainer.new()
		margin_container.add_theme_constant_override("margin_top", 10)
		margin_container.add_theme_constant_override("margin_left", 20)
		margin_container.add_theme_constant_override("margin_bottom", 10)
		margin_container.add_theme_constant_override("margin_right", 20)
		vbox_container.add_child(margin_container)

		# HBoxContainer für horizontales Layout
		var hcontainer = HBoxContainer.new()
		hcontainer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		margin_container.add_child(hcontainer)

		# TextureRect für Icon
		var icon_texture = TextureRect.new()
		icon_texture.texture = preload("res://icon_stats/Damage.png")  # Pfad zum Icon
		icon_texture.expand = true
		icon_texture.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		hcontainer.add_child(icon_texture)

		# Label für Item-Name
		var name_label: Label = Label.new()
		name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		name_label.text = item["name"]  # Access item name
		name_label.add_theme_font_override("font", preload("res://addons/gut/fonts/CourierPrime-Bold.ttf"))
		name_label.add_theme_color_override("font_color", Color(1, 1, 1))  # Weißer Text
		name_label.add_theme_constant_override("margin_left", 10)  # Abstand links
		hcontainer.add_child(name_label)

		# Label für Preis
		var price_label: Label = Label.new()
		price_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		price_label.text = str(new_item_price) + " Gold"  # Access item price
		price_label.add_theme_font_override("font", preload("res://addons/gut/fonts/CourierPrime-Bold.ttf"))
		price_label.add_theme_color_override("font_color", Color(1, 0.84, 0))  # Goldener Text
		price_label.add_theme_constant_override("margin_right", 10)  # Abstand rechts
		hcontainer.add_child(price_label)

		# Button für Kauf
		var buy_button: Button = Button.new()

		# Button-Styling
		var button_style = StyleBoxFlat.new()
		button_style.bg_color = Color("#4e357e")  # Hintergrundfarbe des Buttons
		button_style.border_width_left = 5
		button_style.border_width_top = 5
		button_style.border_width_right = 5
		button_style.border_width_bottom = 5
		button_style.border_color = Color(0.8, 0.8, 0.8)  # Rahmenfarbe
		button_style.corner_radius_top_left = 5
		button_style.corner_radius_top_right = 5
		button_style.corner_radius_bottom_left = 5
		button_style.corner_radius_bottom_right = 5

		buy_button.add_theme_stylebox_override("normal", button_style)

		# Hover-Styling
		var hover_style = StyleBoxFlat.new()
		hover_style.bg_color = Color("#6e50a1")  # Etwas helleres Lila bei Hover
		hover_style.border_width_left = 5
		hover_style.border_width_top = 5
		hover_style.border_width_right = 5
		hover_style.border_width_bottom = 5
		hover_style.border_color = Color(1, 1, 1)  # Weißer Rahmen bei Hover
		hover_style.corner_radius_top_left = 5
		hover_style.corner_radius_top_right = 5
		hover_style.corner_radius_bottom_left = 5
		hover_style.corner_radius_bottom_right = 5

		buy_button.add_theme_stylebox_override("hover", hover_style)

		# Gedrückter Zustand (pressed)
		var pressed_style = StyleBoxFlat.new()
		pressed_style.bg_color = Color("#34215a")  # Dunkleres Lila
		pressed_style.border_width_left = 5
		pressed_style.border_width_top = 5
		pressed_style.border_width_right = 5
		pressed_style.border_width_bottom = 5
		pressed_style.border_color = Color(0.6, 0.6, 0.6)  # Grauer Rahmen
		pressed_style.corner_radius_top_left = 5
		pressed_style.corner_radius_top_right = 5
		pressed_style.corner_radius_bottom_left = 5
		pressed_style.corner_radius_bottom_right = 5

		buy_button.add_theme_stylebox_override("pressed", pressed_style)

		if current_player.coins < new_item_price:
			buy_button.text = "Too poor"
			buy_button.disabled = true
			buy_button.add_theme_color_override("font_color", Color(0.5, 0.5, 0.5))  # Grauer Text
		else:
			buy_button.text = "Buy"
			buy_button.connect("pressed", Callable(self, "_on_buy_button_pressed").bind(key))  # Pass the item's key
			buy_button.add_theme_color_override("font_color", Color(1, 1, 1))  # Weißer Text
		
		buy_button.add_theme_font_override("font", preload("res://addons/gut/fonts/CourierPrime-Bold.ttf"))
		buy_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		hcontainer.add_child(buy_button)

		# Horizontale Linie
		vbox_container.add_child(HSeparator.new())

func populate_shop4():
	for key in shop_items.keys():
		var item = shop_items[key]
		var new_item_price = round(item["price"] * Global.price_multi)

		# MarginContainer für Abstand und Styling
		var margin_container = MarginContainer.new()
		margin_container.add_theme_constant_override("margin_top", 10)
		margin_container.add_theme_constant_override("margin_left", 20)
		margin_container.add_theme_constant_override("margin_bottom", 10)
		margin_container.add_theme_constant_override("margin_right", 20)
		vbox_container.add_child(margin_container)

		# HBoxContainer für horizontales Layout
		var hcontainer = HBoxContainer.new()
		hcontainer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		margin_container.add_child(hcontainer)

		# TextureRect für Icon
		var icon_texture = TextureRect.new()
		icon_texture.texture = preload("res://icon_stats/Damage.png")  # Pfad zum Icon
		icon_texture.expand = true
		icon_texture.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		hcontainer.add_child(icon_texture)

		# Label für Item-Name
		var name_label: Label = Label.new()
		name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		name_label.text = item["name"]  # Access item name
		name_label.add_theme_font_override("font", preload("res://addons/gut/fonts/CourierPrime-Bold.ttf"))
		name_label.add_theme_color_override("font_color", Color(1, 1, 1))  # Weißer Text
		name_label.add_theme_constant_override("margin_left", 10)  # Abstand links
		hcontainer.add_child(name_label)

		# Label für Preis
		var price_label: Label = Label.new()
		price_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		price_label.text = str(new_item_price) + " Gold"  # Access item price
		price_label.add_theme_font_override("font", preload("res://addons/gut/fonts/CourierPrime-Bold.ttf"))
		price_label.add_theme_color_override("font_color", Color(1, 0.84, 0))  # Goldener Text
		price_label.add_theme_constant_override("margin_right", 10)  # Abstand rechts
		hcontainer.add_child(price_label)

		# Button für Kauf
		var buy_button: Button = Button.new()

		# Button-Styling mit StyleBoxFlat
		var button_style = StyleBoxFlat.new()
		button_style.bg_color = Color("#4e357e")  # Hintergrundfarbe des Buttons
		button_style.border_width_left = 5
		button_style.border_width_top = 5
		button_style.border_width_right = 5
		button_style.border_width_bottom = 5
		button_style.border_color = Color(0.8, 0.8, 0.8)  # Rahmenfarbe
		button_style.corner_radius_top_left = 5
		button_style.corner_radius_top_right = 5
		button_style.corner_radius_bottom_left = 5
		button_style.corner_radius_bottom_right = 5

		# Hover-Styling
		var hover_style = StyleBoxFlat.new()
		hover_style.bg_color = Color("#6e50a1")  # Etwas helleres Lila bei Hover
		hover_style.border_width_left = 5
		hover_style.border_width_top = 5
		hover_style.border_width_right = 5
		hover_style.border_width_bottom = 5
		hover_style.border_color = Color(1, 1, 1)  # Weißer Rahmen bei Hover
		hover_style.corner_radius_top_left = 5
		hover_style.corner_radius_top_right = 5
		hover_style.corner_radius_bottom_left = 5
		hover_style.corner_radius_bottom_right = 5

		# Gedrückter Zustand (pressed)
		var pressed_style = StyleBoxFlat.new()
		pressed_style.bg_color = Color("#34215a")  # Dunkleres Lila
		pressed_style.border_width_left = 5
		pressed_style.border_width_top = 5
		pressed_style.border_width_right = 5
		pressed_style.border_width_bottom = 5
		pressed_style.border_color = Color(0.6, 0.6, 0.6)  # Grauer Rahmen
		pressed_style.corner_radius_top_left = 5
		pressed_style.corner_radius_top_right = 5
		pressed_style.corner_radius_bottom_left = 5
		pressed_style.corner_radius_bottom_right = 5

		# Stile anwenden
		buy_button.add_theme_stylebox_override("normal", button_style)
		buy_button.add_theme_stylebox_override("hover", hover_style)
		buy_button.add_theme_stylebox_override("pressed", pressed_style)

		# Text und Verhalten
		if current_player.coins < new_item_price:
			buy_button.text = "Too poor"
			buy_button.disabled = true
			buy_button.add_theme_color_override("font_color", Color(0.5, 0.5, 0.5))  # Grauer Text
		else:
			buy_button.text = "Buy"
			buy_button.connect("pressed", Callable(self, "_on_buy_button_pressed").bind(key))  # Pass the item's key
			buy_button.add_theme_color_override("font_color", Color(1, 1, 1))  # Weißer Text
		
		buy_button.add_theme_font_override("font", preload("res://addons/gut/fonts/CourierPrime-Bold.ttf"))
		buy_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		hcontainer.add_child(buy_button)

		# Horizontale Linie
		vbox_container.add_child(HSeparator.new())

func populate_shop():
	for key in shop_items.keys():
		var item = shop_items[key]
		var new_item_price = round(item["price"] * Global.price_multi)

		# MarginContainer für Abstand und Styling
		var margin_container = MarginContainer.new()
		margin_container.add_theme_constant_override("margin_top", 20)
		margin_container.add_theme_constant_override("margin_left", 20)
		margin_container.add_theme_constant_override("margin_bottom", 20)
		margin_container.add_theme_constant_override("margin_right", 20)
		vbox_container.add_child(margin_container)

		# HBoxContainer für horizontales Layout
		var hcontainer = HBoxContainer.new()
		hcontainer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		margin_container.add_child(hcontainer)

		# TextureRect für Icon
		var icon_texture = TextureRect.new()
		icon_texture.texture = load("res://icon_stats/" + key + "Damage.png")  # Beispiel
		icon_texture.expand = true
		icon_texture.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		hcontainer.add_child(icon_texture)

		# Label für Item-Namee
		var name_label: Label = Label.new()
		name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		name_label.text = item["name"]  # Access item name
		name_label.add_theme_font_override("font", preload("res://addons/gut/fonts/CourierPrime-Bold.ttf"))
		name_label.add_theme_color_override("font_color", Color(1, 1, 1))  # Weißer Text
		name_label.add_theme_constant_override("margin_left", 10)  # Abstand links
		hcontainer.add_child(name_label)

		# Label für Preis
		var price_label: Label = Label.new()
		price_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		price_label.text = str(new_item_price) + " Gold"  # Access item price
		price_label.add_theme_font_override("font", preload("res://addons/gut/fonts/CourierPrime-Bold.ttf"))
		price_label.add_theme_color_override("font_color", Color(1, 0.84, 0))  # Goldener Text
		price_label.add_theme_constant_override("margin_right", 10)  # Abstand rechts
		hcontainer.add_child(price_label)

		# Button für Kauf
		var buy_button: Button = Button.new()
		if current_player.coins < new_item_price:
			buy_button.text = "Too poor"
			buy_button.disabled = true
		else:
			buy_button.text = "Buy"
			buy_button.connect("pressed", Callable(self, "_on_buy_button_pressed").bind(key))  # Pass the item's key
		buy_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		hcontainer.add_child(buy_button)

		# Horizontale Linie
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
