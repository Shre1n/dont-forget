extends CharacterBody2D

# -- Exportierte Variablen für Dropdown-Auswahl --
@export_category("Gegner Type")
@export var stats_file_path: String = "res://gegner/slime/slime.json"
@export_enum("default","strong_enemy") var selected_profile: String = "default"

# -- Variablen für Min/Max-Stats und Drops --
var min_stats: Dictionary
var max_stats: Dictionary
var min_drops: Dictionary
var max_drops: Dictionary
var special_type: Dictionary
var extra_data: Dictionary
var profiles_data: Dictionary

@export_category("Einstellungen")
@export var tutorial: bool = false
@export var level_nr: int = 1

@export_subgroup("Idle Timer")
@export var idle_time_min: float = 1.0  # Mindestwartezeit im Idle-Zustand
@export var idle_time_max: float = 5.0  # Maximalwartezeit im Idle-Zustand

# Bis 3500 erhöhbar
@export_subgroup("Stats")
@export var life_stat = 29
@export var damage_stat = 5
@export var crit_dmg_stat = 40
@export var res_stat = 0
@export var speed_stat = 250
@export var imunity_stat = 0
@export var pierce_stat = 0  # Durchschlagskraft (Extra Schaden)
@export var crit_stat = 100  # Kritische Trefferchance (0–1000 = 0–100%)
@export var knockback_stat = 150  # Knockback-Stärke
@export var knockback_res_stat = 0 # Knockback-Resistenz

@export var jump_stat = 0
@export var attack_speed_stat = 0 
@export var cooldown_stat = 0
@export var reaction_stat = 0
@export var deception_stat = 0
@export var fear_stat = 0

@export_subgroup("Balancing")
@export var knockback_duration: float = 0.2
@export var post_knockback_duration = 0.6  # Dauer der Nach-Knockback-Phase

@export_subgroup("Debugging")
@export var orientation_left: bool = false
@export var damaged: bool = false
@export var alive: bool = true

var drop := preload("res://scenes/drop.tscn")
var current_Itemholder

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var animated_player: AnimationPlayer = $AnimationPlayer
@onready var chase_anim: AnimationPlayer = $Chase_Anim
@onready var direction_timer: Timer = $Direction_Timer
@onready var weapon = $CollisionPolygon2D/Attack_Area

var direction: int = 0  # -1 für links, 1 für rechts, 0 für idle

var character: Character = null
var character_chase: bool = false

var is_knocked_back: bool = false
var knockback_timer: float = 0.0
var knockback_direction: Vector2 = Vector2.ZERO
var knockback_speed: float = 300.0
var knockback_speed_new : float
var post_knockback_timer = 0.0

var life
var damage
var speed
var resistenz
var imunity
var knockback_res
var all_stats 
var weight

var elite = false
var mini_boss = false

func _ready():
	var gamemanager = find_game_manager()
	current_Itemholder = gamemanager.connect("current_Itemholder", Callable(self, "save_user_location"))
	randomize()
	load_stats_from_file()
	apply_profile_data()
	special_load()
	if !tutorial:
		update_start_stats()
	update_status()
	start_new_behavior()

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
		min_stats = profile["min_stats"]
		max_stats = profile["max_stats"]
		min_drops = profile["min_drops"]
		max_drops = profile["max_drops"]
		special_type = profile["special_type"]
		extra_data = profile["extra_data"]
		#print("Min/Max stats and drops applied for profile: ", selected_profile)
	else:
		print("Profile not found: ", selected_profile)
		# Standardwerte setzen
		min_stats = {}
		max_stats = {}
		min_drops = {}
		max_drops = {}
		special_type = {}
		extra_data = {}

func special_load():
	elite = special_type["elite"]
	mini_boss = special_type["mini_boss"]

func update_start_stats():
	# Verwende die Min/Max-Werte aus der geladenen JSON-Datei
	if min_stats and max_stats and !tutorial:
		life_stat = randf_range(min_stats["life_stat"], max_stats["life_stat"]) * (0.8 + (0.2 * level_nr))
		damage_stat = randf_range(min_stats["damage_stat"], max_stats["damage_stat"]) * (0.95 + (0.05 * level_nr))
		crit_dmg_stat = randf_range(min_stats["crit_dmg_stat"], max_stats["crit_dmg_stat"]) * (0.97 + (0.03 * level_nr))
		res_stat = randf_range(min_stats["res_stat"], max_stats["res_stat"]) * (0.99 + (0.01 * level_nr))
		speed_stat = randf_range(min_stats["speed_stat"], max_stats["speed_stat"])  * (0.99 + (0.01 * level_nr))
		imunity_stat = randf_range(min_stats["imunity_stat"], max_stats["imunity_stat"]) * (0.99 + (0.01 * level_nr))
		pierce_stat = randf_range(min_stats["pierce_stat"], max_stats["pierce_stat"]) * (0.99 + (0.01 * level_nr))
		crit_stat = randf_range(min_stats["crit_stat"], max_stats["crit_stat"]) * (0.95 + (0.05 * level_nr))
		knockback_stat = randf_range(min_stats["knockback_stat"], max_stats["knockback_stat"]) * (0.99 + (0.01 * level_nr))
		knockback_res_stat = randf_range(min_stats["knockback_res_stat"], max_stats["knockback_res_stat"]) * (0.99 + (0.01 * level_nr))
		jump_stat = randf_range(min_stats["jump_stat"], max_stats["jump_stat"])  * (1 + (0.01 * level_nr))
		attack_speed_stat = randf_range(min_stats["attack_speed_stat"], max_stats["attack_speed_stat"]) * (0.9 + (0.1 * level_nr))
		cooldown_stat = randf_range(min_stats["cooldown_stat"], max_stats["cooldown_stat"]) * (0.95 + (0.05 * level_nr))
		reaction_stat = randf_range(min_stats["reaction_stat"], max_stats["reaction_stat"]) * (0.95 + (0.01 * level_nr))
		deception_stat = randf_range(min_stats["deception_stat"], max_stats["deception_stat"])
		fear_stat = randf_range(min_stats["fear_stat"], max_stats["fear_stat"])
		#print("Randomized stats applied within min/max range")
	else:
		print("Min/Max stats not properly loaded, using defaults")

func update_status():
	life = calculate_stats_to_value(life_stat, 0.0, 1.0, 0.0, 3500.0, 3500.0)
	if elite:
		life = life * 10
	elif mini_boss:
		life = life * 100
	speed = calculate_stats_to_value(speed_stat, 0.0 , 1.0, 20.0, 600.0, 3500.0) 
	resistenz = calculate_stats_to_value(res_stat, 0.0, 1.0, 0.0, 7000.0, 3500.0)
	imunity = calculate_stats_to_value(imunity_stat, 0.0, 1.0, 1, 0.01, 3500.0)
	knockback_res = calculate_stats_to_value(knockback_res_stat, 0.0, 1.0, 1, 0.01, 3500.0)
	all_stats = life_stat + damage_stat + crit_dmg_stat + res_stat + speed_stat + imunity_stat + pierce_stat + crit_stat + knockback_stat + knockback_res_stat
	weight = min(490, all_stats / 100)
	
	weapon.damage = max(1, damage_stat)
	weapon.pierce_multi = pierce_stat
	weapon.crit_chance = crit_stat
	weapon.crit_multi = max(1, crit_dmg_stat)
	weapon.knockback = knockback_stat

func calculate_stats_to_value(stat: int, span_start: float, span_end: float, min_value: float, max_value: float, divider: float = 1000.0) -> float:
	var stat_factor = clamp(stat / divider, span_start, span_end)
	return lerp(min_value, max_value, stat_factor)

func _physics_process(delta):
	if !alive:
		velocity = Vector2.ZERO
	elif is_knocked_back:
		handle_knockback(delta)
	elif character_chase:
		chase_character()
	else:
		move_in_direction()
		
	apply_gravity(delta)
	move_and_slide()
	update_animation()

func apply_gravity(delta):
	if !is_on_floor():
		velocity.y += ProjectSettings.get_setting("physics/2d/default_gravity") * delta
	else:
		velocity.y = 0

func handle_knockback(delta):
	if knockback_timer > 0:
		# Wende Knockback an
		knockback_timer -= delta
		velocity.x = knockback_direction.x * knockback_speed_new
	elif post_knockback_timer > 0:
		# Reduziere Geschwindigkeit nach Knockback
		post_knockback_timer -= delta
		velocity = velocity.move_toward(Vector2.ZERO, knockback_speed_new * delta)
		if velocity.length() < 10:  # Geschwindigkeitsschwelle für Ende der Nach-Knockback-Phase
			velocity = Vector2.ZERO
			post_knockback_timer = 0
			is_knocked_back = false
	else:
		# Knockback abgeschlossen
		is_knocked_back = false

func chase_character():
	if character:
		var direction_to_character = (character.global_position - global_position).normalized()
		direction = direction_calcX(direction_to_character)
		velocity.x = direction * speed

func direction_calcX(newGoal):
	var new_direction
	if newGoal.x > 0:
		new_direction = 1  # Nach rechts
	elif newGoal.x < 0:
		new_direction = -1  # Nach links
	else:
		new_direction = 0  # Stillstand
	return new_direction

func move_in_direction():
	velocity.x = direction * speed

func start_new_behavior():
	direction = randi() % 3 - 1  # -1 (links), 0 (idle), 1 (rechts)
	direction_timer.wait_time = randf_range(idle_time_min, idle_time_max)
	direction_timer.start()

func _on_direction_timer_timeout():
	start_new_behavior()

func update_animation():
	if !alive:
		return
	if damaged:
		return

	match direction:
		0:
			animated_player.play("idle")
		-1:
			if !orientation_left:
				flip_sprite()
			animated_player.play("walk")
		1:
			if orientation_left:
				flip_sprite()
			animated_player.play("walk")

func flip_sprite():
	$".".scale.x *= -1
	orientation_left = !orientation_left

func _on_detection_area_body_entered(body):
	if body is Character:
		chase_anim.play("chase")
		character = body
		character_chase = true
		direction_timer.stop()

func _on_detection_area_body_exited(body):
	if body is Character and character == body:
		chase_anim.play("lost")
		character = null
		character_chase = false
		start_new_behavior()

func take_damage(damage, pierce, knockback_power_in, damage_position, falle):
	var effective_damage = ceil((max(1, damage - resistenz) + pierce) * imunity)
	var knockback_effect = knockback_power_in * knockback_res
	life -= damage
	damaged = true
	animated_player.play("hurt")
	if life <= 0:
		die()
	elif (knockback_effect) > weight:
		knockback(knockback_effect, damage_position)

func knockback(knockback, damage_position):
	if character:
		knockback_direction.x = direction_calcX((global_position - character.global_position).normalized())
		knockback_speed_new = knockback
		knockback_timer = 0.2
		post_knockback_timer = post_knockback_duration
		is_knocked_back = true

func die():
	alive = false
	animated_player.play("death")

func _on_animation_player_animation_finished(anim_name: String):
	if anim_name == "death":
		add_new_drop(global_position)
		queue_free()

func find_game_manager():
	var root = get_tree().root  # Root-Node des Scene Trees
	for child in root.get_children():
		if child.name == "Game_Manager":
			return child
	return null

func add_new_drop(death_pos):
	var gold_drop = randi_range(min_drops["gold"], max_drops["gold"])
	var time_drop = randi_range(min_drops["time"], max_drops["time"])
	instantiate_drop_items(gold_drop, death_pos, false)  # False for gold
	if !tutorial:
		# Drop time items
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
