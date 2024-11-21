extends Control

signal no_deal

@onready var game_manager = find_game_manager()
var current_player

@onready var sand_display = $SandDisplay #UI Elemente
@onready var amount_label = $GridContainer/Menge
var max_time: float = 10.0
var elapsed_time: float = 0.0  # Tracks the elapsed time
var amplitude: float = 10.0  # Adjust for intensity of the sinusoidal wave
var frequency: float = 2.0   # Adjust for speed of oscillation

@export var coins = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	sand_display.size.x = 60
	game_manager.connect("current_user", Callable(self, "save_user_location"))
	game_manager.connect("back_to_village", Callable(self, "total_reset"))
	game_manager.connect("lifetimer", Callable(self, "update_lifetime_display"))
	
	amount_label.text = str(coins)

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
		amount_label.text = str(coins)
	else:
		emit_signal("no_deal")

func total_reset():
	coin_reset()

func coin_reset():
	coins = 0

func update_lifetime_display(time):
	if sand_display:
		var percentage = time/ max_time
		sand_display.scale.x = percentage


func find_game_manager():
	var root = get_tree().root  # Root-Node des Scene Trees
	for child in root.get_children():
		if child.name == "Game_Manager":
			return child
	return null
