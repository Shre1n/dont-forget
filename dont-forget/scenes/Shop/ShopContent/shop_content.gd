extends Control

var shop_items: Array =  [{ "name": "damage", "price": 100 }]

@onready var grid_containter: GridContainer = $GridContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	populate_shop()


func populate_shop():
	for item in shop_items:
		var hbox: HBoxContainer = HBoxContainer.new()
		var name_label: Label = Label.new()
		name_label.text = item.name
		hbox.add_child(name_label)
		
		var price_label: Label = Label.new()
		price_label.text = str(item.price) + "Gold"
		hbox.add_child(price_label)
		
		var buy_button: Button = Button.new()
		buy_button.text = "Buy"
		buy_button.connect("pressed", Callable(self, "_on_buy_button_pressed"))
		hbox.add_child(buy_button)
		
		grid_containter.add_child(hbox)

func _on_buy_button_pressed(item):
	print("Purchased: ", item.name)
