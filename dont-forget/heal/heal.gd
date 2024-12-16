extends Node2D

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var sprite = $Sprite
@onready var character = $"../../Character"
@onready var col = $InteractionArea/CollisionShape2D

@export_category("Einstellungen")
@export var test = false
@export var value = 150
@export_subgroup("Type")
@export var stats_file_path: String = "res://heal/heal.json"
@export_enum("default","broken") var selected_profile: String = "default"

var data: Dictionary
var profiles_data: Dictionary

func _ready():
	load_stats_from_file()
	apply_profile_data()
	if !test:
		update_start_stats()
	interaction_area.interact = Callable(self, "on_pick_up")
	
func on_pick_up():
	character.get_time(value)
	sprite.queue_free()
	interaction_area.queue_free()

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
		value = data["value"]
		sprite.texture = load(data["sprite"])
		var shape = CircleShape2D.new()
		shape.radius = data["collision_size"]
		col.shape = shape
	else:
		print("No Data")

#Beispiel Json:
#"default": {
	#"value": 150,
	#"sprite": "res://textures/sprite.png",
	#"collision_size": [100, 100]
#}
