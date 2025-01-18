extends Control

@export var game_manager : Game_Manager
@onready var volume_slider = $Panel/Panel/VBoxContainer/HSplitContainer/VSplitContainer/Volume
@onready var mute_toggler = $Panel/Panel/VBoxContainer/HSplitContainer/Mute
@onready var button_audio = $Audio_Stream

#Standartwerte
const basic_volume = 100
const basic_mute = false
const basic_res = Vector2i(1920,1080)
const basic_fullscreen = false
const max_volume_db = 0.0

var save_value_from_slider: float

var user_prefs: UserPreferences

func _ready():
	user_prefs = UserPreferences.load_or_create()
	if	volume_slider && user_prefs.volume:
		volume_slider.value = user_prefs.volume
	if	mute_toggler:
		mute_toggler.set_pressed(user_prefs.check_mute)
		_on_mute_toggled(user_prefs.check_mute)
	hide()

func _process(delta):
	pass

func _on_close_btn_pressed():
	button_audio.button_audio()
	if (game_manager != null):
		game_manager.options_closed()
		return
	hide()

func _on_volume_value_changed(value):
	save_value_from_slider = value
	var volume_db = lerp(-20.0, max_volume_db, value / 100.0)
	AudioServer.set_bus_volume_db(0, volume_db)
	if user_prefs:
		user_prefs.volume = value
		user_prefs.save()

func _on_mute_toggled(toggled_on):
	AudioServer.set_bus_mute(0, toggled_on)
	if toggled_on:
		volume_slider.editable = false
		button_audio.button_audio()
		volume_slider.tooltip_text = "Stumm geschaltet"
	else:
		volume_slider.editable = true
		volume_slider.tooltip_text = "Verschiebe um die Gesamtlautstärke anzupassen"
	if user_prefs:
		user_prefs.check_mute = toggled_on
		user_prefs.save()


func _on_reset_btn_pressed():
	button_audio.button_audio()
	reset_settings()

func reset_settings():
	button_audio.button_audio()
	var volume_db = lerp(-20.0, max_volume_db, save_value_from_slider / 100.0)
	AudioServer.set_bus_volume_db(0, volume_db)
	volume_slider.value = basic_volume
	
	AudioServer.set_bus_mute(0, basic_mute)
	mute_toggler.set_pressed(basic_mute)


func _on_volume_drag_started() -> void:
	button_audio.button_audio()
