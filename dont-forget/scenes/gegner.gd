extends Node2D

@export var enemy_notifier: VisibleOnScreenNotifier2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Hint.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_enemy_visibility_screen_entered() -> void:
	$Hint.visible = true


func _on_enemy_visibility_screen_exited() -> void:
	$Hint.visible = false
