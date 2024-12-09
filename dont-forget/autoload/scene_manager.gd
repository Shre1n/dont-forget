extends Node

signal load_start(loading_screen)
signal scene_added(loaded_scene:Node,loading_screen)
signal load_complete(loaded_scene:Node)

signal _content_finished_loading(content)
signal _content_invalid(content_path:String)
signal _content_failed_to_load(content_path:String)

var _loading_screen_scene:PackedScene = preload("res://ui/loading_screen.tscn")
var _loading_screen:LoadingScreen
var _transition:String
var _content_path:String
var _load_progress_timer:Timer
var _load_scene_into:Node 
var _scene_to_unload:Node
var _loading_in_progress:bool = false


func _ready() -> void:
	var screen_size = DisplayServer.screen_get_size()
	DisplayServer.window_set_size(screen_size)
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	_content_invalid.connect(_on_content_invalid)
	_content_failed_to_load.connect(_on_content_failed_to_load)
	_content_finished_loading.connect(_on_content_finished_loading)

func _add_loading_screen(transition_type:String="fade_to_black"):
	_transition = "no_to_transition" if transition_type == "no_transition" else transition_type
	_loading_screen = _loading_screen_scene.instantiate() as LoadingScreen
	#get_tree().root.add_child(_loading_screen)
	var canvas_layer = CanvasLayer.new()
	get_tree().root.add_child(canvas_layer)
	canvas_layer.add_child(_loading_screen)
	_loading_screen.start_transition(_transition)
	

func swap_scenes(scene_to_load:String, load_into:Node=null, scene_to_unload:Node=null, transition_type:String="fade_to_black") -> void:
	
	if _loading_in_progress:
		push_warning("SceneManager is already loading something")
		return
	
	_loading_in_progress = true
	if load_into == null: load_into = get_tree().root
	_load_scene_into = load_into
	_scene_to_unload = scene_to_unload
	
	_add_loading_screen(transition_type)
	_load_content(scene_to_load)



func _load_content(content_path:String) -> void:
	load_start.emit(_loading_screen)
	await _loading_screen.transition_in_complete
		
	_content_path = content_path
	var loader = ResourceLoader.load_threaded_request(content_path)
	if not ResourceLoader.exists(content_path) or loader == null:
		_content_invalid.emit(content_path)
		return
	
	_load_progress_timer = Timer.new()
	_load_progress_timer.wait_time = 0.1
	_load_progress_timer.timeout.connect(_monitor_load_status)
	
	get_tree().root.add_child(_load_progress_timer)
	_load_progress_timer.start()

func _monitor_load_status() -> void:
	var load_progress = []
	var load_status = ResourceLoader.load_threaded_get_status(_content_path, load_progress)

	match load_status:
		ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
			_content_invalid.emit(_content_path)
			_load_progress_timer.stop()
			return
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			if _loading_screen != null:
				_loading_screen.update_bar(load_progress[0] * 100) # 0.1
		ResourceLoader.THREAD_LOAD_FAILED:
			_content_failed_to_load.emit(_content_path)
			_load_progress_timer.stop()
			return
		ResourceLoader.THREAD_LOAD_LOADED:
			_load_progress_timer.stop()
			_load_progress_timer.queue_free()
			_content_finished_loading.emit(ResourceLoader.load_threaded_get(_content_path).instantiate())
			return

func _on_content_failed_to_load(path:String) -> void:
	printerr("error: Failed to load resource: '%s'" % [path])

func _on_content_invalid(path:String) -> void:
	printerr("error: Cannot load resource: '%s'" % [path])
	

func _on_content_finished_loading(incoming_scene) -> void:
	var outgoing_scene = _scene_to_unload
	
	_load_scene_into.add_child(incoming_scene)
	scene_added.emit(incoming_scene,_loading_screen)
	
	if _scene_to_unload != null:
		if _scene_to_unload != get_tree().root: 
			_scene_to_unload.queue_free()
	
	if _loading_screen != null:
		_loading_screen.finish_transition()
		await _loading_screen.anim_player.animation_finished
	
	_loading_in_progress = false
	load_complete.emit(incoming_scene)
