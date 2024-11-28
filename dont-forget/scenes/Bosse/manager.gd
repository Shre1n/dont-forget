extends Node2D


@export var boss_scenes: Dictionary = {
	"Drexus": preload("res://scenes/Bosse/Endboss/sceen/Endboss.tscn")
}

func spawn_boss(boss_name: String, position: Vector2):
	if boss_name in boss_scenes:
		var boss_instance = boss_scenes[boss_name].instantiate()
		boss_instance.position = position
		add_child(boss_instance)
		boss_instance.connect("boss_defeated", Callable(self, "_on_boss_defeated"))
		boss_instance.connect("boss_engaged", Callable(self, "_on_boss_engaged"))
		print("Spawning boss:", boss_name)


func _on_boss_defeated(boss_name):
	print("BossManager: Boss", boss_name, "defeated! Trigger post-battle logic.")

func _on_boss_engaged(boss_name):
	print("BossManager: Boss", boss_name, "engaged! Prepare battle area.")
