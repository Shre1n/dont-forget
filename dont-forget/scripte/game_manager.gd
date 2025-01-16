class_name Game_Manager extends Node2D

signal toggle_game_paused(is_paused : bool)
signal death
signal current_user(path)
signal current_Itemholder(path)
signal lifetimer(time)
signal back_to_village
	#SceneManager.swap_scenes("res://scenes/village.tscn",get_tree().root,self,"transition_type")
	#SceneManager.swap_scenes("res://ui/menu.tscn",get_tree().root,self,"transition_type")

@onready var level_holder: Node2D = $Level_Folder
@onready var life: Timer = $Life_Timer
@onready var gold: Label = $Pause_Menu/UI/GridContainer/Menge
@export var life_time:float = 10.0
@export var max_time: float = 300.0

@export var audio: AudioStreamPlayer2D

@onready var canvaslayer = $Pause_Menu

var tutorial = preload("res://scenes/tutorial.tscn")
var bag_scene = preload("res://assets/drops/bag_drop/bag.tscn")
var save_user: save_User

var current_level:Level
var current_character
var options_open = false
var controls_open = false
var game_paused : bool = false:
	get:
		return game_paused
	set(value):
		game_paused = value
		get_tree().paused = game_paused
		emit_signal("toggle_game_paused", game_paused)

var damage_stat = 10
var crit_dmg_stat = 0
var res_stat = 0
var speed_stat = 250
var jump_stat = 250
var imunity_stat = 0
var attack_speed_stat = 250
var cooldown_stat = 250
var pierce_stat = 0
var crit_stat = 0
var knockback_stat = 50
var knockback_res_stat = 0
var dash_cooldown_stat = 250
var dash_speed_stat = 0
var extra_weight_stat = 0

var user_save = save_User.load_save()

var all_stats_in_dict: Dictionary = {}

var all_stats = damage_stat + crit_dmg_stat + res_stat + speed_stat + jump_stat + imunity_stat + attack_speed_stat + cooldown_stat + pierce_stat + crit_stat + knockback_stat + knockback_res_stat + dash_cooldown_stat+ dash_speed_stat

func _ready():
	load_saved_scene()
	SceneManager.load_complete.connect(_on_level_loaded)
	SceneManager.load_start.connect(_on_load_start)
	SceneManager.scene_added.connect(_on_level_added)
	#Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	#Zum Village zurück (braucht signal mit path)
	current_character.connect("going_back", Callable(self, "scene_change"))
	get_node("Pause_Menu/UiManager").connect("give_user", Callable(self, "give_user"))
	


func play_bg_music_Village():
	var sound = preload("res://Sounds/Musik/BG_Musik.mp3")
	

func give_user():
	emit_signal("current_user", current_character)
	
func show_light():
	if current_level.level_nr == 2 and current_character and current_level.name != "Village":
		current_character.get_node("Light").show()

func get_all_stats() -> Dictionary:
	var all_stats_in_dict = {
		"damage_stat": damage_stat,
		"crit_dmg_stat": crit_dmg_stat,
		"res_stat": res_stat,
		"speed_stat": speed_stat,
		"jump_stat": jump_stat,
		"imunity_stat": imunity_stat,
		"attack_speed_stat": attack_speed_stat,
		"cooldown_stat": cooldown_stat,
		"pierce_stat": pierce_stat,
		"crit_stat": crit_stat,
		"knockback_stat": knockback_stat,
		"knockback_res_stat": knockback_res_stat,
		"dash_cooldown_stat": dash_cooldown_stat,
		"dash_speed_stat": dash_speed_stat,
		"extra_weight_stat": extra_weight_stat
	}
	return all_stats_in_dict

func load_saved_scene():
	var user_save = save_User.load_save()
	save_user = user_save
	var saved_scene_path = save_user.scene_path
	var bag_scene = save_user.bag_scene

	#Entfernt alle alten Level-Inhalte
	for child in level_holder.get_children():
			child.queue_free()
	
	# Loads save or Fallback
	if saved_scene_path != null:
		var saved_scene_instance = saved_scene_path.instantiate() as Level
		if saved_scene_instance:
			level_holder.add_child(saved_scene_instance)
		else:
			#print("failed to instance saved scene. Loading Tutorial.")
			level_holder.add_child(tutorial.instantiate() as Level)
	else:
		level_holder.add_child(tutorial.instantiate() as Level)
		#print("Fallback to tutorial.")
	
	current_level = level_holder.get_child(0) as Level
	current_character = find_character(current_level)
	find_Itemholder(current_level)

	# Player init
	if current_character:
		# Renew the connections
		current_character.connect("lifeChange", Callable(self, "life_timer_update"))
		current_character.connect("going_back", Callable(self, "scene_change"))
		current_character.connect("add_bag", Callable(self, "add_bag"))

		if saved_scene_path != null:
			current_character.position = save_user.position_of_character
			current_character.coins = user_save.gold
			gold.text = str(user_save.gold)
			life_time = user_save.life

			# Timer starts if all values are set
			await get_tree().process_frame
			life.start(save_user.life)
			all_stats_in_dict = user_save.stats
	
	show_light()


	# Renew Bag
	if user_save.bag_scene:
		var bag_instance = user_save.bag_scene.instantiate()
		get_tree().root.add_child(bag_instance)
		if user_save.bag_position:
			bag_instance.position = user_save.bag_position  # Restore the position
		#print("Bag instance restored at position ", bag_instance.position)
		#print("Bag instance restored.")
	#else:
		#print("No Bag scene saved. Skipping Bag restoration.")

func add_bag(bag_scene):
	for child in get_tree().root.get_children():
		if child.name == "Bag":
			child.queue_free()
			child.call_deferred("free")
			#print("Removed existing Bag instance:", child)
	call_deferred("add_child_as_bag", bag_scene)

func add_child_as_bag(bag_scene):
	var bag_instance = bag_scene.instantiate()
	get_tree().root.add_child(bag_instance)
	bag_instance.name = "Bag"
	bag_instance.position = current_character.position
	bag_instance.set_coins(current_character.coins)
	current_character.coins = 0
	user_save.level_nr = current_level.level_nr
	#user_save.bag_scene = bag_instance
	#user_save.bag_position = current_character.position
	user_save.gold = current_character.coins


func find_character(level):
	for child in level.get_children():
		if child.name == "Character":
			emit_signal("current_user", child)
			return child
	return null

func find_Itemholder(level):
	for child in level.get_children():
		if child.name == "Itemholder":
			emit_signal("current_Itemholder", child)
			return child
	return null

func _input(event : InputEvent):
	if(event.is_action_pressed("menu")):
		if $Pause_Menu/UiManager.visible: 
			$Pause_Menu/UiManager.extra_close()
			$Pause_Menu/UiManager.close()
		elif(options_open):
			options_closed()
		elif (controls_open):
			controls_closed()
		else:
			game_paused = !game_paused

func save_scene():
	var user_save = save_User.load_save()
	var current_scene = get_child(0).get_child(0).scene_file_path
	user_save.scene_path = load(String(current_scene)) # Get the current scene's path
	save_user.position_of_character = current_character.position
	user_save.life = life.time_left
	user_save.gold = gold.text
	user_save.gold = current_character.coins
	user_save.save()


func _on_level_loaded(level) -> void:
	if level is Level:
		current_level = level
		find_Itemholder(level)
	#Signale zum Character neu verbinden nach einem Scene wechsel
		current_character = find_character(current_level)
		current_character.connect("lifeChange", Callable(self, "life_timer_update"))
		#Zum Menü zurück
		current_character.connect("going_back", Callable(self, "scene_change"))
		#Zum Village zurück (braucht signal mit path)
		#current_character.connect("going_back", Callable(self, "scene_change"))
		show_light()
		save_scene()

func new_Itemholder_Shout():
	find_Itemholder(current_level)

func _on_level_added(_level,_loading_screen) -> void:
	if _loading_screen != null:
		var loading_parent: Node = _loading_screen.get_parent() as Node
		loading_parent.move_child(_loading_screen, loading_parent.get_child_count()-1)

func _on_load_start(_loading_screen):
	pass
	#für wenn man das UI über der Lade Animation haben will, später

func _process(delta):
	if !life.is_stopped():
		var percentage = life.time_left/ max_time
		emit_signal("lifetimer", percentage)

func options_opend():
	options_open = true
	get_node("Pause_Menu/Options").show()

func options_closed():
	options_open = false
	get_node("Pause_Menu/Options").hide()

func controls_closed():
	controls_open = false
	get_node("Pause_Menu/Controls").hide()

func controls_opend():
	controls_open = true
	get_node("Pause_Menu/Controls").show()

func _on_life_timer_timeout() -> void:
	save_bag_with_user()
	emit_signal("death")
	#SceneManager.swap_scenes("res://ui/menu.tscn",get_tree().root,self,"transition_type")


func life_timer_update(amount):
	if life.is_stopped():
		return
	if life.time_left + amount <= 0:
		life.stop()
		save_bag_with_user()
		emit_signal("death")
		emit_signal("lifetimer", 1)
	elif	life.time_left + amount < max_time:
		life.start(life.time_left + amount)
	else:
		life.start(max_time)
	#print(life.time_left)

func restart_life_timer():
	life.start(max_time)

func save_bag_with_user():
	if save_user:
		save_user.scene_path = load(current_level.scene_file_path)
		save_user.bag_position = current_character.position

		add_bag(bag_scene)
		save_user.save()

#Zum Menü zurück
#func scene_change():

	#SceneManager.swap_scenes("res://ui/menu.tscn",get_tree().root,self,"transition_type")

#Zum Village zurück
func scene_change():
	emit_signal("back_to_village")
	SceneManager.swap_scenes("res://scenes/Village.tscn",level_holder,current_level,"fade_to_white")
