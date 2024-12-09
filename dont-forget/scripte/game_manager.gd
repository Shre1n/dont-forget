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
@export var max_time: float = 100.0

@onready var canvaslayer = $Pause_Menu

var tutorial = preload("res://scenes/tutorial.tscn")
var save_user: save_User

var current_level:Level
var current_character
var options_open = false
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
var cooldown_stat = 0
var pierce_stat = 0
var crit_stat = 0
var knockback_stat = 50
var knockback_res_stat = 0

var all_stats = damage_stat + crit_dmg_stat + res_stat + speed_stat + jump_stat + imunity_stat + attack_speed_stat + cooldown_stat + pierce_stat + crit_stat + knockback_stat + knockback_res_stat

func _ready():
	load_saved_scene()
	SceneManager.load_complete.connect(_on_level_loaded)
	SceneManager.load_start.connect(_on_load_start)
	SceneManager.scene_added.connect(_on_level_added)
	#Zum Village zurück (braucht signal mit path)
	#current_character.connect("going_back", Callable(self, "scene_change"))
	


func load_saved_scene():
	var user_save = save_User.load_save()
	save_user = user_save
	var saved_scene_path = save_user.scene_path
	
	for child in level_holder.get_children():
			child.queue_free()
	
	if saved_scene_path != null:
		var saved_scene_instance = saved_scene_path.instantiate() as Level
		if saved_scene_instance:
			level_holder.add_child(saved_scene_instance)
			print("Loaded saved scene: ", saved_scene_instance)
			gold.text = user_save.gold
			life_time = user_save.life
		else:
			print("failed to instance saved scene. Loading Tutorial.")
			level_holder.add_child(tutorial.instantiate() as Level)
	else:
		level_holder.add_child(tutorial.instantiate() as Level)
		print("Fallback to tutorial.")
	
	current_level = level_holder.get_child(0) as Level
	current_character = find_character(current_level)
	find_Itemholder(current_level)
	if current_character:
		if saved_scene_path != null:
			current_character.position = save_user.position_of_character
		current_character.connect("lifeChange", Callable(self, "life_timer_update"))
		current_character.connect("going_back", Callable(self, "scene_change"))
	
	

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
		if(options_open):
			options_closed()
		else:
			game_paused = !game_paused

func save_scene():
	var user_save = save_User.load_save()
	var current_scene = get_child(0).get_child(0).scene_file_path
	user_save.scene_path = load(String(current_scene)) # Get the current scene's path
	save_user.position_of_character = current_character.position
	user_save.life = life_time
	user_save.gold = gold.text
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
		save_scene()

func _on_level_added(_level,_loading_screen) -> void:
	if _loading_screen != null:
		var loading_parent: Node = _loading_screen.get_parent() as Node
		loading_parent.move_child(_loading_screen, loading_parent.get_child_count()-1)

func _on_load_start(_loading_screen):
	pass
	#für wenn man das UI über der Lade Animation haben will, später

func _process(delta):
	if !life.is_stopped():
		emit_signal("lifetimer", life.time_left)

func options_opend():
	options_open = true
	get_node("Pause_Menu/Options").show()

func options_closed():
	options_open = false
	get_node("Pause_Menu/Options").hide()


func _on_life_timer_timeout() -> void:
	emit_signal("death")
	#SceneManager.swap_scenes("res://ui/menu.tscn",get_tree().root,self,"transition_type")


func life_timer_update(amount):
	if life.is_stopped():
		return
	if life.time_left + amount <= 0:
		life.stop()
		emit_signal("death")
	elif	life.time_left + amount < max_time:
		life.start(life.time_left + amount)
	else:
		life.start(max_time)
	#print(life.time_left)

func restart_life_timer():
	life.start(max_time)

#Zum Menü zurück
func scene_change():
	SceneManager.swap_scenes("res://ui/menu.tscn",get_tree().root,self,"transition_type")

#Zum Village zurück
#func scene_change(path):
	#emit_signal("back_to_village")
	#SceneManager.swap_scenes(path,level_holder,current_level,"transition_type")
