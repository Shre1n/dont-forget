class_name Game_Manager extends Node2D

signal toggle_game_paused(is_paused : bool)
signal death
signal current_user(path)
signal lifetimer(time)
signal back_to_village

	#SceneManager.swap_scenes("res://scenes/village.tscn",get_tree().root,self,"transition_type")
	#SceneManager.swap_scenes("res://ui/menu.tscn",get_tree().root,self,"transition_type")

@onready var level_holder: Node2D = $Level_Folder
@onready var life: Timer = $Life_Timer
@export var life_time:float = 10.0
@export var max_time: float = 100.0

@onready var canvaslayer = $Pause_Menu

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

func _ready():
	SceneManager.load_complete.connect(_on_level_loaded)
	SceneManager.load_start.connect(_on_load_start)
	SceneManager.scene_added.connect(_on_level_added)
	current_level = level_holder.get_child(0) as Level
	current_character = find_character(current_level)
	current_character.connect("lifeChange", Callable(self, "life_timer_update"))
	#Zum Menü zurück
	current_character.connect("going_back", Callable(self, "scene_change"))
	#Zum Village zurück (braucht signal mit path)
	#current_character.connect("going_back", Callable(self, "scene_change"))



func find_character(level):
	for child in level.get_children():
		if child.name == "Character":
			emit_signal("current_user", child)
			return child
	return null

func _input(event : InputEvent):
	if(event.is_action_pressed("menu")):
		if(options_open):
			options_closed()
		else:
			game_paused = !game_paused

func _on_level_loaded(level) -> void:
	if level is Level:
		current_level = level
	#Signale zum Character neu verbinden nach einem Scene wechsel
		current_character = find_character(current_level)
		current_character.connect("lifeChange", Callable(self, "life_timer_update"))
		#Zum Menü zurück
		current_character.connect("going_back", Callable(self, "scene_change"))
		#Zum Village zurück (braucht signal mit path)
		#current_character.connect("going_back", Callable(self, "scene_change"))

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
	if life.time_left + amount <= 0:
		life.stop()
		emit_signal("death")
	elif	life.time_left + amount <= max_time:
		life.start(life.time_left + amount)
	else:
		life.start(max_time)
	print(life.time_left)

#Zum Menü zurück
func scene_change():
	SceneManager.swap_scenes("res://ui/menu.tscn",get_tree().root,self,"transition_type")

#Zum Village zurück
#func scene_change(path):
	#emit_signal("back_to_village")
	#SceneManager.swap_scenes(path,level_holder,current_level,"transition_type")
