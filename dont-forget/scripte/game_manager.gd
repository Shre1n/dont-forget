class_name Game_Manager extends Node2D

@onready var level_holder: Node2D = $Level_Folder

var current_level:Level

func _ready():
	SceneManager.load_complete.connect(_on_level_loaded)
	SceneManager.load_start.connect(_on_load_start)
	SceneManager.scene_added.connect(_on_level_added)
	current_level = level_holder.get_child(0) as Level

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
