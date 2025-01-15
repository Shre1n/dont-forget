extends Node2D

@onready var sprite = $Sprite
@onready var col = $Attack_Area/CollisionShape2D
@onready var weapon = $Attack_Area

@export_category("Einstellungen")
@export var test = false
@export_subgroup("Test")
@export var damage: int = 0
@export var pierce: int = 0
@export var crit_chance: int = 0
@export var crit_multi: int = 0
@export var knockback: int = 0
@export var sprite_path: String = "res://fallen/spike/Spikes_.png"
@export var size: Vector2 = Vector2(116, 45)
@export_subgroup("Script")
@export var stats_file_path: String = "res://fallen/spike/spike.json"
@export_subgroup("")
@export_enum("default", "sponge", "very_sharp") var selected_profile: String = "default"

var data: Dictionary
var profiles_data: Dictionary

func _ready():
	load_stats_from_file()
	apply_profile_data()
	if !test:
		update_start_stats()
	else:
		test_func()

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
		data = profile["data"]
	else:
		print("Profile not found: ", selected_profile)
		# Standardwerte setzen
		data = {}

func update_start_stats():
	if data:
		weapon.damage = data["damage"]
		weapon.pierce_multi = data["pierce"]
		weapon.crit_chance = data["crit_chance"]
		weapon.crit_multi = data["crit_multi"]
		weapon.knockback = data["knockback"]
		sprite.texture = load(data["sprite"])
		var shape = RectangleShape2D.new()
		shape.size = Vector2(data["collision_size"][0], data["collision_size"][1])
		col.shape = shape
	else:
		print("No Data")

func test_func():
	weapon.damage = damage
	weapon.pierce_multi = pierce
	weapon.crit_chance = crit_chance
	weapon.crit_multi = crit_multi
	weapon.knockback = knockback
	sprite.texture = load(sprite_path)
	var shape = RectangleShape2D.new()
	shape.size = size
	col.shape = shape

#Beispiel Json:
#"default": {
	#"data":{
		#"damage": 150,
		#"pierce": 150,
		#"crit_chance": 150,
		#"crit_multi": 150,
		#"knockback": 150,
		#"sprite": "res://textures/sprite.png",
		#"collision_size": [100, 100]
	#}
#}
