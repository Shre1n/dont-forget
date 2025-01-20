extends Control

@export var game_manager : Game_Manager
@onready var volume_slider = $Panel/Panel/VBoxContainer/HSplitContainer/VSplitContainer/Volume
@onready var mute_toggler = $Panel/Panel/VBoxContainer/HSplitContainer/Mute

@onready var button_pressed_audio = $button_pressed


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
	button_pressed_audio.play()
	if (game_manager != null):
		game_manager.options_closed()
		return
	hide()

func _on_mute_toggled(toggled_on):
	if toggled_on:
		volume_slider.editable = false
		button_pressed_audio.play()
		volume_slider.tooltip_text = "Stumm geschaltet"
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)  # Mute aktivieren

	else:
		volume_slider.editable = true
		volume_slider.tooltip_text = "Verschiebe um die Gesamtlautstärke anzupassen"
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)  # Mute deaktivieren

	if user_prefs:
		user_prefs.check_mute = toggled_on
		user_prefs.save()


func _on_reset_btn_pressed():
	button_pressed_audio.play()
	reset_settings()

func reset_settings():
	volume_slider.value = basic_volume
	var volume_db = lerp(-80.0, 0.0, basic_volume / 100.0)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), volume_db)
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), basic_mute)
	mute_toggler.set_pressed(basic_mute)
