extends Control

signal no_deal

@onready var game_manager = find_game_manager()
var current_player

@export var coins = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	game_manager.connect("current_user", Callable(self, "save_user_location"))
	game_manager.connect("back_to_village", Callable(self, "total_reset"))
	game_manager.connect("lifetimer", Callable(self, "update_lifetime_display"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func save_user_location(path):
	current_player = path
	current_player.connect("coinsChange", Callable(self, "coin_update"))

func coin_update(amount):
	var sum = coins + amount
	if sum > 0:
		coins = coins + amount
	else:
		emit_signal("no_deal")
	print(coins)

func total_reset():
	coin_reset()

func coin_reset():
	coins = 0

func update_lifetime_display(time):
	pass

func find_game_manager():
	var root = get_tree().root  # Root-Node des Scene Trees
	for child in root.get_children():
		if child.name == "Game_Manager":
			return child
	return null
