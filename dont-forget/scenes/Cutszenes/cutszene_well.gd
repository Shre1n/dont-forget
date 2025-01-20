extends Node2D

@onready var anim_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anim_player.play("fall")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	



func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fall":
		anim_player.play("falling")
