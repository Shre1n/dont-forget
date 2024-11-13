extends Control

@export var game_manager : Game_Manager
@onready var volume_slider = $Panel/Panel/VBoxContainer/HSplitContainer/VSplitContainer/Volume
@onready var mute_toggler = $Panel/Panel/VBoxContainer/HSplitContainer/Mute
@onready var resulutions_selector = $Panel/Panel/VBoxContainer/HSplitContainer2/Resulutions
@onready var fullscreen_toggler = $Panel/Panel/VBoxContainer/HSplitContainer2/Fullscreen

#Standartwerte
const basic_volume = 100
const basic_mute = false
const basic_res = Vector2i(1280,720)
const basic_fullscreen = false

func _ready():
	hide()

func _process(delta):
	pass

func _on_close_btn_pressed():
	if (game_manager != null):
		game_manager.options_closed()
		return
	hide()

func _on_volume_value_changed(value):
	AudioServer.set_bus_volume_db(0, value)

func _on_mute_toggled(toggled_on):
	AudioServer.set_bus_mute(0, toggled_on)
	if toggled_on:
		volume_slider.editable = false
		volume_slider.tooltip_text = "Stumm geschaltet"
	else:
		volume_slider.editable = true
		volume_slider.tooltip_text = "Verschiebe um die Gesamtlautstärke anzupassen"

func _on_fullscreen_toggled(toggled_on):
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_resulutions_item_selected(index):
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(1920,1080))
		1:
			DisplayServer.window_set_size(Vector2i(1600,900))
		2:
			DisplayServer.window_set_size(Vector2i(1280,720))


func _on_reset_btn_pressed():
	reset_settings()

func reset_settings():
	AudioServer.set_bus_volume_db(0, basic_volume)
	volume_slider.value = basic_volume
	
	AudioServer.set_bus_mute(0, basic_mute)
	mute_toggler.set_pressed(basic_mute)
	
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if basic_fullscreen else DisplayServer.WINDOW_MODE_WINDOWED)
	fullscreen_toggler.set_pressed(basic_fullscreen) 
	
	DisplayServer.window_set_size(basic_res)
	resulutions_selector.selected = 2 
