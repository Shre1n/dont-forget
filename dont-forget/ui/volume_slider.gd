extends HSlider

var user_prefs: UserPreferences


func _value_changed(new_value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), new_value)
	if user_prefs:
		user_prefs.volume = new_value
		user_prefs.save()
