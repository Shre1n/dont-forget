class_name UserPreferences extends Resource

@export_range(0,1,0.5) var volume: float = 1.0
@export var check_mute: bool = false

func save() -> void:
	ResourceSaver.save(self, "user://user_prefs.tres")
	
static func load_or_create() -> UserPreferences:
	var res: UserPreferences = load("user://user_prefs.tres") as UserPreferences
	if !res:
		res = UserPreferences.new()
	return res
