extends Control


@export var item_name: String
@export var item_price: int

@onready var name_label: Label = $NameLabel
@onready var price_label: Label = $PriceLabel


func set_item(item: Dictionary):
	item_name = item["name"]
	item_price = item["price"]
	name_label.text = item_name
	price_label.text = str(item_price)
