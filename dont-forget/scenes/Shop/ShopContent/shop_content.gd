extends Control

var shop_items: Array =  [{ "name": "damage", "price": 100 }]

@onready var vbox_container: VBoxContainer = $VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	populate_shop()


func populate_shop():
	for item in shop_items:
		var hcontainer = HBoxContainer.new()
		vbox_container.add_child(hcontainer)
		var name_label: Label = Expanding_Label.new()
		name_label.text = item.name
		hcontainer.add_child(name_label)
		
		var price_label: Label = Expanding_Label.new()
		price_label.text = str(item.price) + " Gold"
		hcontainer.add_child(price_label)
		
		var buy_button: Button = Expanding_Button.new()
		buy_button.text = "Buy"
		buy_button.connect("pressed", Callable(self, "_on_buy_button_pressed"))
		hcontainer.add_child(buy_button)
		
		vbox_container.add_child(HSeparator.new())
		
		for child in hcontainer.get_children():
			print(child)


func _on_buy_button_pressed(item):
	print("Purchased: ", item.name)
