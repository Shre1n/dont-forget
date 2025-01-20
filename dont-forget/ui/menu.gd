class_name StartScreen extends Control

#@export var game_manager : Game_Manager
@onready var load_button: Button = $Panel/Panel/VBoxContainer/Load_Button
#@onready var button_audio: Audio_Stream = $Audio_Stream

@onready var button_pressed_audio = $button_pressed
@onready var leaves_audio = $leaves

var user_save: save_User

var options_open: bool = false
var controls_open: bool = false

func _input(event : InputEvent):
	if(event.is_action_pressed("ui_cancel") and options_open):
		options_open = false
		get_node("Options").hide()
	elif (event.is_action_pressed("ui_cancel") and controls_open):
		controls_open =false
		get_node("Controls").hide()

func _ready():
	if !FileAccess.file_exists("user://user_save_point.tres"):
		load_button.disabled = true
		load_button.focus_mode = Control.FOCUS_NONE
	else:
		load_button.disabled = false
		load_button.focus_mode = Control.FOCUS_ALL

func _process(delta):
	pass


func _on_start_button_pressed():
	button_pressed_audio.play()
	var user_save = save_User.create()
	user_save.save()
	SceneManager.swap_scenes("res://game.tscn",get_tree().root,self,"wipe_to_right")


func _on_load_button_pressed():
	button_pressed_audio.play()
	var user_save = save_User.load_save()
	
	if user_save.scene_path != null:
		SceneManager.swap_scenes("res://game.tscn",get_tree().root,self,"wipe_to_right")
	else:
		push_warning("No saved game found! Start a new game.")
		_on_start_button_pressed()
	
func _on_options_button_pressed():
	button_pressed_audio.play()
	options_open = true
	get_node("Options").show()




func _on_credits_button_pressed():
	button_pressed_audio.play()
	pass # Replace with function body.


func _on_quit_button_pressed():
	button_pressed_audio.play()
	get_tree().quit()


func _on_controls_pressed() :
	button_pressed_audio.play()
	controls_open = true
	get_node("Controls").show()
