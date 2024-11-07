extends Control


func _ready():
	hide()

func _process(delta):
	pass


func _on_close_btn_pressed():
	hide()


func _on_volume_value_changed(value):
	AudioServer.set_bus_volume_db(0, value)


func _on_mute_toggled(toggled_on):
	AudioServer.set_bus_mute(0, toggled_on)


func _on_fullscreen_toggled(toggled_on):
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
