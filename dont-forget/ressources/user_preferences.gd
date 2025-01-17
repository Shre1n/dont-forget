class_name UserPreferences extends Resource

@export_range(0,1,0.01) var volume: float = 1.0
@export var check_mute: bool = false

func save() -> void:
	ResourceSaver.save(self, "user://user_prefs.tres")
	
static func load_or_create() -> UserPreferences:
	var res: UserPreferences = load("user://user_prefs.tres") as UserPreferences
	if !res:
		res = UserPreferences.new()
	return res

# Prozentsatz (0-1) in einen dB-Wert (-20 bis 0)
func volume_to_db() -> float:
	print("V", volume)
	print("§$", lerp(-80.0, 0.0, volume))
	
	if volume < 0:
		volume = 0  # Korrigiere, falls der Wert kleiner als 0 ist
	elif volume > 1:
		volume = 1  # Korrigiere, falls der Wert größer als 1 ist
	
	return lerp(-80.0, 0.0, volume)

# Wandelt den dB-Wert in einen Prozentwert (0-1)
static func db_to_volume(db: float) -> float:
	return (db + 80.0) / 80.0  # Mappt den Bereich -20 bis 0 auf 0-1
