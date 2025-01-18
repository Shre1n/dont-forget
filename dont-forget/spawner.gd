extends Node2D

signal share_current_character

@export var max_limit: int = 5
# Gegner-Typen und maximale Anzahl mit Profil
@export var enemy_types = [
	{"path": "", "max_count": 3, "selected_profile": "default", "new_scale": 0.2, "loners": false},
	{"path": "", "max_count": 2, "selected_profile": "default", "new_scale": 0.2, "loners": false},
	{"path": "", "max_count": 1, "selected_profile": "default", "new_scale": 0.2, "loners": true}
]

# Respawn-Timer
@export var respawn_delay: float = 60.0
@export var wait_time: float = 0.2
@onready var respawn_timer = $Respawn_Timer
var current_Itemholder
@onready var audio = $Audio_Stream

var loner_spawned = false

func _ready():
	audio.spawner_audio()
	var gamemanager = find_game_manager()
	current_Itemholder = gamemanager.connect("current_Itemholder", Callable(self, "save_user_location"))
	respawn_timer.wait_time = respawn_delay
	spawn_enemies()

func get_enemy_limit() -> int:
	var total = 0
	for enemy_data in enemy_types:
		total += enemy_data["max_count"]
	return total

func spawn_enemies():
	while get_child_count() < (max_limit + 1) and !loner_spawned:
		var enemy_data = select_random_enemy_type()
		if enemy_data != null:
			var spawn_count = enemy_data["max_count"]
			if enemy_data["loners"]:
				loner_spawned = true
			for i in range(spawn_count):
				if get_child_count() >= (max_limit + 1):
					break
				if get_child_count() < max_limit + 1:
					await get_tree().create_timer(wait_time).timeout
					spawn_enemy(enemy_data)

func select_random_enemy_type():
	var valid_types = []
	for enemy_data in enemy_types:
		if get_child_count() == 1 or not enemy_data["loners"]:
			valid_types.append(enemy_data)
	if valid_types.size() > 0:
		return valid_types[randi() % valid_types.size()]

func spawn_enemy(enemy_data: Dictionary):
	var path = enemy_data["path"]
	var enemy_scene = load(path).instantiate()
	enemy_scene.selected_profile = enemy_data["selected_profile"]
	enemy_scene.scale.x = enemy_data["new_scale"]
	enemy_scene.scale.y = enemy_data["new_scale"]
	#enemy_scene.spawner = true
	enemy_scene.current_Itemholder = current_Itemholder
	
	add_child(enemy_scene)
	print(get_children())

func _on_child_exiting_tree(node):
	if not respawn_timer.is_stopped():
		return
	respawn_timer.start()

func _on_respawn_timer_timeout():
	if get_child_count() == 1:
		loner_spawned = false
	if get_child_count() < (max_limit+1) and !loner_spawned:
		spawn_enemies()
		print("test")

func find_game_manager():
	var root = get_tree().root  # Root-Node des Scene Trees
	for child in root.get_children():
		if child.name == "Game_Manager":
			return child
	return null

func save_user_location(path):
	current_Itemholder = path
