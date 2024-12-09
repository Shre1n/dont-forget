class_name save_User extends Resource


@export var scene_path: PackedScene
@export var bag_scene: PackedScene
@export var gold: String
@export var life: float
@export var position_of_character: Vector2

func save() -> void:
	ResourceSaver.save(self, "user://user_save_point.tres")


static func create() -> save_User:
	var res = save_User.new()
	res.save()
	return res
	
static func load_save() -> save_User:
	var res: save_User = load("user://user_save_point.tres") as save_User
	return res
