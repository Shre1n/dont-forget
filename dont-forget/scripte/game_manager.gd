class_name Game_Manager extends Node2D

signal toggle_game_paused(is_paused : bool)


@onready var level_holder: Node2D = $Level_Folder
@onready var life: Timer = $Life_Timer
@export var life_time:float = 10.0
@export var max_time: float = 10.0

var current_level:Level
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

func _input(event : InputEvent):
	if(event.is_action_pressed("ui_cancel")):
		if(options_open):
			options_closed()
		else:
			game_paused = !game_paused

func _on_level_loaded(level) -> void:
	if level is Level:
		current_level = level

func _on_level_added(_level,_loading_screen) -> void:
	if _loading_screen != null:
		var loading_parent: Node = _loading_screen.get_parent() as Node
		loading_parent.move_child(_loading_screen, loading_parent.get_child_count()-1)

func _on_load_start(_loading_screen):
	pass
	#für wenn man das UI über der Lade Animation haben will, später

func _process(delta):
	pass

func options_opend():
	options_open = true
	get_node("Pause_Menu/Options").show()

func options_closed():
	options_open = false
	get_node("Pause_Menu/Options").hide()


func _on_life_timer_timeout() -> void:
	pass # Replace with function body.
