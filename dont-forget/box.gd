extends RigidBody2D
@export var test: bool = false
@export var life = 500
@export var amor = 0
@export var imunity = 1 #1-0
@onready var sprite = $Sprite2D

@export var stats_file_path: String = "res://objekte/kiste/reg.json"
@export_enum("default","stone_block","metal_block","gold_block","wall_block","simple_treasure_chest","wood_treasure_chest","iron_treasure_chest","bronze_treasure_chest","gold_treasure_chest","diamand_treasure_chest") var selected_profile: String = "default"

@onready var timer = $Timer

@onready var break_sound = $Break

var stats: Dictionary
var min_drops: Dictionary
var max_drops: Dictionary
var extra_data: Dictionary
var profiles_data: Dictionary

@export var visible_notifier: VisibleOnScreenNotifier2D

@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var coll_shape = $CollisionShape2D
@onready var dmg_area = $Damage_Area

var drop := preload("res://scenes/drop.tscn")
var current_Itemholder



func update_sprite():
	if extra_data.has("sprite"):
		var sprite_path = extra_data["sprite"]
		if ResourceLoader.exists(sprite_path):  # Überprüfen, ob die Ressource existiert
			sprite.texture = load(sprite_path)
			#print("Sprite loaded: ", sprite_path)
		else:
			print("Sprite path does not exist: ", sprite_path)

# Called when the node enters the scene tree for the first time.
func _ready():
	var gamemanager = find_game_manager()
	current_Itemholder = gamemanager.connect("current_Itemholder", Callable(self, "save_user_location"))
	randomize()
	load_stats_from_file()
	apply_profile_data()
	if !test:
		update_start_stats()
		update_sprite()

		
func load_stats_from_file():
	var file = FileAccess.open(stats_file_path, FileAccess.READ)
	if file:
		var json_data = file.get_as_text()
		var json = JSON.new()
		var parse_result = json.parse(json_data)
		if parse_result == OK:
			profiles_data = json.data
			#print("Stats loaded: ", profiles_data)
		else:
			print("Error parsing JSON file: ", parse_result)
		file.close()
	else:
		print("Could not open file: ", stats_file_path)

func apply_profile_data():
	if profiles_data.has("profiles") and profiles_data["profiles"].has(selected_profile):
		var profile = profiles_data["profiles"][selected_profile]
		stats = profile["stats"]
		min_drops = profile["min_drops"]
		max_drops = profile["max_drops"]
		extra_data = profile["extra_data"]
		#print("Min/Max stats and drops applied for profile: ", selected_profile)
	else:
		print("Profile not found: ", selected_profile)
		# Standardwerte setzen
		stats = {}
		min_drops = {}
		max_drops = {}
		extra_data = {}

func update_start_stats():
	if stats:
		life  = stats["life_stat"]
		amor = stats["amor_stat"]
		imunity = 1 - (stats["imunity_stat"]/100)
	else:
		print("Min/Max stats not properly loaded, using defaults")

func find_game_manager():
	var root = get_tree().root  # Root-Node des Scene Trees
	for child in root.get_children():
		if child.name == "Game_Manager":
			return child
	return null

func take_damage(damage, pierce, knockback_power_in, damage_position, falle):
	life = life - ((max(0, damage-amor) + pierce) * imunity)
	anim_player.play("damage")
	if life <= 0:
		die()
		

func die():
	break_sound.play()
	add_new_drop(global_position)
	timer.start()
	queue_free()

func add_new_drop(death_pos):
	var gold_drop = randi_range(min_drops["gold"], max_drops["gold"])
	var time_drop = randi_range(min_drops["time"], max_drops["time"])
	instantiate_drop_items(gold_drop, death_pos, false)  # False for gold
	instantiate_drop_items(time_drop, death_pos, true)  # True for time


func instantiate_drop_items(drop_count, death_pos, is_time_item):
	for i in range(drop_count):
		var item = drop.instantiate()  # Assuming 'drop' is the base scene for both types
		item.position = death_pos
		
		# Set the type of item (gold or time)
		item.time = is_time_item
		
		# Add item to the scene and group
		current_Itemholder.call_deferred("add_child", item)
		item.add_to_group("items")

func save_user_location(path):
	current_Itemholder = path


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	sprite.show()
	coll_shape.show()
	dmg_area.show()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	sprite.hide()
	coll_shape.hide()
	dmg_area.hide()


func _on_timer_timeout() -> void:
	queue_free()
